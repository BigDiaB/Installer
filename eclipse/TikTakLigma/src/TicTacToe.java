import java.awt.*;
import java.awt.event.*;
import java.util.Arrays;

public class TicTacToe extends Frame implements MouseListener {
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		new TicTacToe().setVisible(true);
	}
	
	private static final long serialVersionUID = 1L;
	
	final private int CROSS = 2;
	final private int CIRCLE = 1;
	final private int EMPTY = -1;
	
	private enum AI_LEVEL {
		AI_SET, AI_DEF, AI_WIN
	};
	
	final private AI_LEVEL AI_DIFFICULTY = AI_LEVEL.AI_WIN; //AI_SET setzt auf leere Felder; AI_DEF verhindert, dass der Spieler gewinnt; AI_WIN bevorzugt eigene Gewinnmöglichkeiten im Gegensatz zu AI_DEF
	final private int AI = CROSS; //CROSS oder CIRCLE für jeweiligen Spieler oder EMPTY für gar keine KI
	final private int NUM_FIELD = 3; //Höhe und Breite des Spielfeldes
	final private int WIN_CONDITION = 3; //Anzahl der Felder, die nebeneinander, untereinander oder diagonal sein müssen, um zu gewinnen. DARF NICHT GRÖßER ALS NUM_FIELD SEIN!!!
	
	final private int TILE_SIZE = 100;
	final private int OS_OFFSET = 0; //Auf MacOS je nach UI Scale: 35; Linux mit tiling wm: 0; Windows: ?
	final private int UI_SPACE = 20;
	final private int UI_OFFSET = TILE_SIZE * NUM_FIELD + OS_OFFSET + 10;
	
			
	private boolean last_draw = false;
	private boolean last_won = false;
	private int current_turn = CIRCLE;
	
	private int gamestate[];
	
	private boolean started = false;
	
	public TicTacToe()  {
		gamestate = new int[NUM_FIELD*NUM_FIELD];
		Arrays.fill(gamestate,EMPTY);
		setSize(TILE_SIZE * NUM_FIELD,UI_OFFSET + UI_SPACE);
		addMouseListener(this);
		addWindowListener(new WindowAdapter(){public void windowClosing(WindowEvent we){System.exit(0);}});
	}
	
	private void ai() {
		int aidx = -1, didx = -1;
		
		int NOT_AI = (AI == CROSS ? CIRCLE : CROSS);
		
		if (AI_DIFFICULTY != AI_LEVEL.AI_SET) {
			for (int i = 0; i < NUM_FIELD * NUM_FIELD; i++) {
				if (gamestate[i] == EMPTY) {
					gamestate[i] = AI;
					if (win(true))
						aidx = i;
					
					gamestate[i] = NOT_AI;
					if (win(true))
						didx = i;
					gamestate[i] = EMPTY;
				}
			}
		}
		
		if ((AI_DIFFICULTY == AI_LEVEL.AI_WIN || didx == -1) && aidx != -1) {
			gamestate[aidx] = AI;
		}
		else if (didx != -1) {
			gamestate[didx] = AI;
		}
		else {
			do {
				aidx = (int)(Math.random() * NUM_FIELD * NUM_FIELD);
			} while(gamestate[aidx] != EMPTY);
			
			gamestate[aidx] = AI;
		}
	}
	
	private boolean is_same_hori(int arr[], int stride, int len) {
		int cmp = arr[stride];
		for (int i = stride; i < stride + len; i++)
			if (arr[i] != cmp)
				return false;
		return true;
	}
	
	private boolean is_same_vert(int arr[], int stride, int len) {
		int cmp = arr[stride];
		for (int k = 0; k < len; k++)
			if (arr[k*NUM_FIELD + stride] != cmp)
				return false;
		return true;
	}
	
	private boolean is_same_diag_nor_x(int arr[], int stride, int len) {
		int cmp = arr[stride];
		for (int k = 0; k < len; k++)
			if (arr[k*NUM_FIELD + stride +k] != cmp)
				return false;
		return true;
	}
	
	private boolean is_same_diag_inv_x(int arr[], int stride,  int len) {
		int cmp = arr[(WIN_CONDITION-1)*NUM_FIELD + stride];
		for (int k = 0; k < len; k++)
			if (arr[(WIN_CONDITION-1 -k)*NUM_FIELD + stride+k] != cmp)
				return false;
		return true;
	}
	
	private boolean win(boolean check)
	{
		int i,j,test;
		for (i = 0; i < NUM_FIELD; i++)
		{
			for (j = 0; j < NUM_FIELD -WIN_CONDITION +1; j++)
			{
				test = 0;
				for (int k = 0; k < WIN_CONDITION; k++)
					test += gamestate[i*NUM_FIELD +j+k];
				if ((test == CROSS*WIN_CONDITION || test == CIRCLE*WIN_CONDITION) && is_same_hori(gamestate,i*NUM_FIELD +j,WIN_CONDITION))
				{
					if (!check) {
						Arrays.fill(gamestate,EMPTY);
						
						for (int k = 0; k < WIN_CONDITION; k++)
							gamestate[i*NUM_FIELD +j+k] = test == CROSS *WIN_CONDITION ? CROSS : CIRCLE;
					}

					return true;
				}
			}
			
			for (j = 0; j < NUM_FIELD -WIN_CONDITION +1; j++)
			{
				test = 0;
				for (int k = 0; k < WIN_CONDITION; k++)
					test += gamestate[(j+k)*NUM_FIELD +i];
				if ((test == CROSS*WIN_CONDITION || test == CIRCLE*WIN_CONDITION) && is_same_vert(gamestate,j*NUM_FIELD +i,WIN_CONDITION))
				{
					if (!check) {
						Arrays.fill(gamestate,EMPTY);
						
						for (int k = 0; k < WIN_CONDITION; k++)
							gamestate[(j+k)*NUM_FIELD +i] = test == CROSS *WIN_CONDITION ? CROSS : CIRCLE;
					}
					return true;
				}
			}
			
			if (i < NUM_FIELD -WIN_CONDITION +1)
			{
				for (j = 0; j < NUM_FIELD -WIN_CONDITION +1; j++)
				{
					test = 0;
					for (int k = 0; k < WIN_CONDITION; k++)
						test += gamestate[(j+k)*NUM_FIELD + i+k];
					if ((test == CROSS*WIN_CONDITION || test == CIRCLE*WIN_CONDITION) && is_same_diag_nor_x(gamestate,j*NUM_FIELD +i, WIN_CONDITION))
					{
						if (!check) {
							Arrays.fill(gamestate,EMPTY);
							
							for (int k = 0; k < WIN_CONDITION; k++)
								gamestate[(j+k)*NUM_FIELD + i+k] = test == CROSS *WIN_CONDITION ? CROSS : CIRCLE;
						}
						return true;
					}
					
					test = 0;
					for (int k = 0; k < WIN_CONDITION; k++)
						test += gamestate[(j+(WIN_CONDITION-1 -k))*NUM_FIELD + i+k];
					if ((test == CROSS*WIN_CONDITION || test == CIRCLE*WIN_CONDITION) && is_same_diag_inv_x(gamestate, i+NUM_FIELD*j,WIN_CONDITION))
					{
						if (!check) {
							Arrays.fill(gamestate,EMPTY);
							
							for (int k = 0; k < WIN_CONDITION; k++)
								gamestate[(j+(WIN_CONDITION-1 -k))*NUM_FIELD + i+k] = test == CROSS *WIN_CONDITION ? CROSS : CIRCLE;
						}
						return true;
					}
				}
			}
		}
		
		return false;
		
	}

	public void paint(Graphics g) {
		
		int x,y;
		boolean draw = true;
		boolean won;
		
		if (last_won) {
			Arrays.fill(gamestate, EMPTY);
			last_won = false;
		}
		
		if (last_draw) {
			Arrays.fill(gamestate, EMPTY);
			last_draw = false;
		}
		
		for (x = 1; x < NUM_FIELD; x++)
		{
			g.drawLine(x * TILE_SIZE, OS_OFFSET, x * TILE_SIZE, OS_OFFSET + TILE_SIZE * NUM_FIELD);
			g.drawLine(0, x * TILE_SIZE + OS_OFFSET, TILE_SIZE * NUM_FIELD, x * TILE_SIZE + OS_OFFSET);
		}
		
	
		won = win(false);
		
		for (x = 0; x < NUM_FIELD; x++)
			for (y = 0; y < NUM_FIELD; y++)
				if (gamestate[y*NUM_FIELD +x] == CIRCLE)
					g.drawOval(x * TILE_SIZE + 10,y * TILE_SIZE + 10 + OS_OFFSET,TILE_SIZE - 20,TILE_SIZE - 20);
				else if (gamestate[y*NUM_FIELD +x] == CROSS)
				{
					g.drawLine(x * TILE_SIZE + 10,
							y * TILE_SIZE + 10 + OS_OFFSET,
							x * TILE_SIZE + 10 + TILE_SIZE - 20,
							y * TILE_SIZE + 10 + OS_OFFSET + TILE_SIZE - 20);
					g.drawLine(x * TILE_SIZE + 10 + TILE_SIZE - 20,
							y * TILE_SIZE + 10 + OS_OFFSET,
							x * TILE_SIZE + 10,
							y * TILE_SIZE + 10 + OS_OFFSET + TILE_SIZE - 20);
				}
				else if (gamestate[y*NUM_FIELD +x] == EMPTY)
					draw = false;
		
		if (won)
		{
			current_turn = -1;
			int winner = 0;
			for (x = 0; x < NUM_FIELD*NUM_FIELD; x++)
				if (gamestate[x] != EMPTY)
				{
					winner = gamestate[x];
					break;
				}
			last_won = true;
			g.drawString("Gewonnen hat: " + (winner == CIRCLE ? "Kreis" : winner == CROSS ? "Kreuz" : "ERROR") + "!\t    Klick => Nochmal", 0, UI_OFFSET + 10);
			started = false;
		}
		else if (draw)
		{
			last_draw = true;
			g.drawString("Unentschieden!\t    Klick => Nochmal", 0, UI_OFFSET + 10);
			started = false;
			if (current_turn == AI) {
				
				if (current_turn == CROSS)
					current_turn = CIRCLE;
				else
					current_turn = CROSS;
			}
		}
		
		if (AI != EMPTY && current_turn == AI) {
			ai();
			
			if (current_turn == CROSS)
				current_turn = CIRCLE;
			else
				current_turn = CROSS;
			
			repaint();
		}
	}

	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub
		
		if (!started)
		{
			started = true;
			repaint();
		}
	
		int x = e.getX(), y = e.getY() - OS_OFFSET,i,j,ix = -1,iy = -1;
		
		for (i = 1; i <= NUM_FIELD; i++)
		{
			for (j = 1; j <= NUM_FIELD; j++)
			{
				if (x > (i-1) * TILE_SIZE && x < i * TILE_SIZE && y > (j-1) * TILE_SIZE && y < j * TILE_SIZE)
				{
					ix = i-1;
					iy = j-1;
				}
			}
		}
		
		if (iy >= 0 && ix >= 0 && gamestate[iy*NUM_FIELD +ix] == EMPTY)
		{
			gamestate[iy*NUM_FIELD +ix] = current_turn;
			
			if (current_turn == CIRCLE)
				current_turn = CROSS;
			else
				current_turn = CIRCLE;
			
			repaint();
		}
	}
	
	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
	}

	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}
}