class Souradnice {
 int x = 0, y = 0; 
 
 Souradnice copy() {
   Souradnice kopie = new Souradnice();
   kopie.x = this.x;
   kopie.y = this.y;
   return kopie;
 }
 
}
