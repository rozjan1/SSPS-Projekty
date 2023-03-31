int pocetCtvercu;
int sirkaCtverecku = 18;
boolean[][] jsouPlne;

void setup() {
  size(1024, 1024);
  pocetCtvercu = width / sirkaCtverecku;
  jsouPlne = new boolean[pocetCtvercu][pocetCtvercu];
}

void mousePressed() {
  int souradniceX = mouseX;
  souradniceX = souradniceX / sirkaCtverecku;

  int souradniceY = mouseY;
  souradniceY = souradniceY / sirkaCtverecku;

  jsouPlne[souradniceX][souradniceY] = !jsouPlne[souradniceX][souradniceY];
}


void keyPressed() {
  if (key == ENTER) {
    jsouPlne = new boolean[pocetCtvercu][pocetCtvercu];
    return;
  }
  
  else if (key == SHIFT) {
    
    return;
  }

  boolean[][] novePole = new boolean[pocetCtvercu][pocetCtvercu];

  for (int x = 0; x < pocetCtvercu; x++) {
    for (int y = 0; y < pocetCtvercu; y++) {

      int sousedi = spoctiSousedy(x, y);
      boolean budeZiva;


      if (jsouPlne[x][y]) {
        if (sousedi < 2) {
          budeZiva = false;
        } else if (sousedi > 3) {
          budeZiva = false;
        } else {
          budeZiva = true;
        }
      } else if (sousedi == 3) {
        budeZiva = true;
      } else {
        budeZiva = false;
      }

      // Ulozit vysledek
      novePole[x][y] = budeZiva;
    }
  }

  jsouPlne = novePole;
}

int spoctiSousedy(int x, int y) {
  int okolniSousedi = 0;
  for (int i = -1; i < 2; i++) {
    int currX = x + i;
    for (int j = -1; j < 2; j++) {
      int currY = y + j;

      if (currX < 0 || currY < 0 || currX >= pocetCtvercu  || currY >= pocetCtvercu) {
        continue;
      } 

      // Policko neni svym sousedem
      if (i == 0 && j == 0) continue;

      if (jsouPlne[currX][currY]) {
        okolniSousedi++;
      }
    }
  }
  return okolniSousedi;
}

void draw() {
  background(255);
  
  for (int radek = 0; radek < pocetCtvercu; radek++) {
    for (int sloupec = 0; sloupec < pocetCtvercu; sloupec++) {
      if (jsouPlne[radek][sloupec] == true) {
        fill(0);
      }
      rect(radek * sirkaCtverecku, sloupec * sirkaCtverecku, sirkaCtverecku, sirkaCtverecku);
      noFill();
    }
  }
}
