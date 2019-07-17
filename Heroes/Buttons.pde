class Buttons {
  String name; //Name of the button
  PVector pos; //Position of the button
  PImage btn; //Btn image

  Buttons( String n, float x, float y) {
    this.name = n;
    pos = new PVector(x, y);
    drawButton();
  }

  void drawButton() {
    /*
    Checks the name of the button and depending on that name, will determin the button to draw.
     Also if the mouse is hovering over the button then change the button to another image
     which tells the user they are in fact hovering over it.
     */
    btn = loadImage("" + name + ".png");
    if (mouseX > pos.x && mouseX < pos.x + btn.width && mouseY > pos.y && mouseY < pos.y + btn.height )
      btn = loadImage("Hover-" + name + ".png");
    image(btn, pos.x, pos.y);
  }

  String buttonPressed(PVector mPos) {
    //Returns the name of the button the decide what action to do.
    if (mPos.x > pos.x && mPos.x < pos.x + btn.width && mPos.y > pos.y && mPos.y < pos.y + btn.height ) 
      return name;
    else 
    return "noPress";
  }
}