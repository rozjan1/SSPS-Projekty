import static javax.swing.JOptionPane.*; //<>//
import java.util.Queue; 
import java.util.LinkedList; 

int velikostCtvercu = 40;
int pocetCtvercu = 25;

Souradnice hlava = new Souradnice();
Souradnice ovoce = new Souradnice();

Smer smer = Smer.UP;
boolean gameRunning = true;
int pokusy = 0;

Queue<Souradnice> ocas = new LinkedList<Souradnice>();

void setup () {
  size(640, 640);
  frameRate(3);
  velikostCtvercu = min(width / pocetCtvercu, height/ pocetCtvercu);
  hlava.x = pocetCtvercu / 2;
  hlava.y = pocetCtvercu / 2;
  generujOvoce();
}

void vitez() {
  showMessageDialog(null, "Vyhral hrac: ", 
    "Vitezstvi", INFORMATION_MESSAGE);
}

void generujOvoce() {
  int x = (int) random(1, pocetCtvercu - 2);
  int y = (int) random(1, pocetCtvercu - 2);
  if (jeVOcasu(x, y) && pokusy < 100) {
    pokusy++;
    generujOvoce();
    return;
  }
  pokusy = 0;
  ovoce.x = x;
  ovoce.y = y;
}

void keyPressed() {
  if (keyCode == UP && smer != Smer.DOWN) smer = Smer.UP;
  else if (keyCode == DOWN && smer != Smer.UP) smer = Smer.DOWN;
  else if (keyCode == LEFT && smer != Smer.RIGHT) smer = Smer.LEFT;
  else if (keyCode == RIGHT && smer != Smer.LEFT) smer = Smer.RIGHT;
}

void draw() {  
  background(255); 

  pohniHadem();

  for (int x = 0; x < pocetCtvercu; x++) {
    for (int y = 0; y < pocetCtvercu; y++) {
      nakresliPolicko(x, y);
    }
  }
}

void pohniHadem() {
  ocas.add(hlava.copy());
  switch(smer) {
  case UP:
    hlava.y--;
    break;

  case DOWN:
    hlava.y++;
    break;

  case LEFT:
    hlava.x--;
    break;

  case RIGHT:
    hlava.x++;
    break;
  }

  if (jeVOcasu(hlava.x, hlava.y)) {
    lose();
  }

  if (seberOvoce()) {
    ocas.add(hlava.copy());
  }

  ocas.poll();

  if (vylezlZMapy()) {
    lose();
  }
}

void lose() {
  println("Prohrals!");
  noLoop();
}

boolean seberOvoce() {
  if (ovoce.x == hlava.x && ovoce.y == hlava.y) {
    generujOvoce();
    System.out.println("Skore: " + ocas.size());
    return true;
  }
  return false;
}

boolean vylezlZMapy() {
  if (hlava.y >= pocetCtvercu - 1) return true;
  else if (hlava.y <= 0) return true;
  else if (hlava.x >= pocetCtvercu -1) return true;
  else if (hlava.x <= 0) return true;
  else return false;
} 

void nakresliPolicko(int x, int y) {
  int worldCoordsX = x * velikostCtvercu;
  int worldCoordsY = y * velikostCtvercu;
  strokeWeight(1);
  stroke(0);
  if (x == hlava.x && y == hlava.y) fill(255, 0, 0);
  else if (jeVOcasu(x, y)) fill(0, 255, 0);
  else if (ovoce.x == x && ovoce.y == y) fill(0, 0, 255);
  else if (x == 0 || y == 0 || x == pocetCtvercu - 1 || y == pocetCtvercu - 1) fill(0);
  rect(worldCoordsX, worldCoordsY, velikostCtvercu, velikostCtvercu);
  noFill();
}

boolean jeVOcasu(int x, int y) {
  Queue<Souradnice> temp = new LinkedList<Souradnice>();
  boolean nasel = false;
  while (ocas.size() > 0) {
    Souradnice a = ocas.poll();
    if (a.x == x && a.y == y) nasel = true;

    temp.add(a);
  }

  ocas = temp;
  return nasel;
}
