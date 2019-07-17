class EnemyAttack {
  //Used for minigames
  PVector pos;
  int size;
  float vx=3, vy=2;
  float ax=0, ay=1;

  EnemyAttack(PVector start, int s) {
    pos = start;
    size = s;
  }

  void move() {
    if (bossAttack == 1 || selectedEnemy.name.equals("Bandit1") || selectedEnemy.name.equals("DarkMage")) {
      pos.y+=5;
      ellipse(pos.x, pos.y, size, size);
    } else if (bossAttack == 2 || selectedEnemy.name.equals("Bandit2") || selectedEnemy.name.equals("DarkArcher")) {
      pos.x-=5;
      ellipse(pos.x, pos.y, size, size);
    } else if (bossAttack == 3 || selectedEnemy.name.equals("Bandit3") || selectedEnemy.name.equals("DarkWarrior")) {
      line( pos.x, pos.y, size, pos.y );
      pos.y+=5;
    } else if (bossAttack == 4 || selectedEnemy.name.equals("Bandit4") || selectedEnemy.name.equals("DarkAssassin")) {
      line( pos.x, pos.y, pos.x, size );
      pos.x-=5;
    }
  }

  boolean collide() {
    if (bossAttack == 1 || selectedEnemy.name.equals("Bandit1")) {
      if (pos.x + size/2 > heartX && pos.x - size/2 < heartX + heart.width && pos.y + size/2 > heartY && pos.y - size/2 < heartY + heart.height) 
        return true;
    } else if (bossAttack == 2 || selectedEnemy.name.equals("Bandit2")) {
      if (pos.x + size/2 > heartX && pos.x - size/2 < heartX + heart.width && pos.y + size/2 > heartY && pos.y - size/2 < heartY + heart.height) 
        return true;
    } else if (bossAttack == 3 || selectedEnemy.name.equals("Bandit3")) {
      if (pos.x + (size-pos.x) > heartX && pos.x - (size-pos.x) < heartX + heart.width && pos.y + 5 > heartY && pos.y - 5 < heartY + heart.height) 
        return true;
    } else if (bossAttack == 4 || selectedEnemy.name.equals("Bandit4")) {
      if (pos.x + 5 > heartX && pos.x - 5 < heartX + heart.width && pos.y + (size-pos.y) > heartY && pos.y - (size-pos.y) < heartY + heart.height)
        return true;       
    }
    return false;
  }
}