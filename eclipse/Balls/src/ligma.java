import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.time.LocalTime;

import javax.swing.JOptionPane;

public class ligma {
	
public static void main(String[] argv) {
		
		System.out.println("Hello, World!");	
	}

	private static double deg_to_rad(double d) {
		return d * Math.PI/180;
	}
	
	private static double rad_to_deg(double r) {
		return r * 180/Math.PI;
	}
	
	static double produkt(double f1, double f2) {
		return f1 * f2;
	}
	
	static boolean gradeZahl(int z) {
		return z%2 == 0;
	}
	
	static void wochentag_stdout(int z) {
		final String days[] = { "Mo", "Di", "Mi", "Do", "Fr", "Sa", "So" };

		if (z >= 0 && z < 7)
			System.out.println(days[z]);
		else
			System.out.println("Error");
	}
	
	static String wochentag_str(int z) {
		final String days[] = { "Mo", "Di", "Mi", "Do", "Fr", "Sa", "So" };

		if (z >= 0 && z < 7)
			return days[z];
		else
			return "Error";
	}
	
	static int dice()
	{
		return (int)(Math.random() * 6 +1);
	}
	
	static float cmp_max(float f1, float f2, float f3) {
		return Math.max(f1, Math.max(f2, f3));
	}
	
	static void time_stdout() {
		LocalTime clock = java.time.LocalTime.now();
		System.out.println(clock.getHour() + ":" + clock.getMinute());
	}


	static String time_str() {
		LocalTime clock = java.time.LocalTime.now();
		return (clock.getHour() + ":" + clock.getMinute());
	}
	
	
	static float BMI(int size_cm, float weight_kg) {
		return weight_kg / (size_cm * size_cm);
	}
	
	static double get_num_regex() {
		String in;
	
		do {
			in = JOptionPane.showInputDialog(null,"Gönn mal Zahl!");
		} while( in == null || in.isEmpty() || in.matches("[a-zA-Z]+") );
		
		return Double.parseDouble(in);
	
	}
	
	static double get_num_trycatch() {
		String in;
		double ret = 0;
		
		do {
			in = JOptionPane.showInputDialog(null,"Gönn mal Zahl!");
			
			try {
				ret = Double.parseDouble(in);
			} catch (Exception e) {
				in = null;
			}
			
		} while(in == null);
		
		return ret;
	}
	
	static boolean write_file(String name, String content) {
		PrintWriter writer;
		
		try {
			writer = new PrintWriter(name, "UTF-8");
		} catch (FileNotFoundException e) {
			return false;
		} catch (UnsupportedEncodingException e) {
			return false;
		}
		
		writer.write(content);
		
		writer.close();
		
		return true;
	}
}