package shawty;

public class passwd {

	private static int is_let(char c) {
		if (c >= 'a' && c <= 'z') return 1; 
		if (c >= 'A' && c <= 'Z') return 2;
		return 0;
	}
	
	private static boolean is_num(char c) {
		return c >= '0' && c <= '9';
	}
	
	final private static int min_len = 8;
	
	private static int prüfePasswortSicherheit(String passwort) {
		String umlaute[] = { "ä", "Ä", "ö", "Ö", "ü", "Ü" };
		int nll, nul, nn, ns;
		nll = nul = nn = ns = 0;
		
		if (passwort.length() < min_len)
			return 0;
		
		for (int i = 0; i < umlaute.length; i++) {
			while(passwort.contains(umlaute[i])) {
				passwort = passwort.replace(umlaute[i], "");
				if (i % 2 == 0) nul++;
				else nll++;
			}
		}
		
		
		System.out.println(passwort);
		
		for (int i = 0; i < passwort.length(); i++)
		{
			nn += is_num(passwort.charAt(i)) ? 1 : 0;
			nll += is_let(passwort.charAt(i)) == 1 ? 1 : 0;
			nul += is_let(passwort.charAt(i)) == 2 ? 1 : 0;
			ns += (!is_num(passwort.charAt(i)) && is_let(passwort.charAt(i)) == 0) ? 1 : 0;
		}
		
		System.out.println("Zahlen: " + nn);
		System.out.println("Groß: " + nul);
		System.out.println("Klein: " + nll);
		System.out.println("Sonder: " + ns);
		
		return 1;
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		prüfePasswortSicherheit("Bälle 123");
	}

}
