//Used to change between gamestates //<>//
int MODE, MENU;
int INFO = 1;
int GAME = 2;
int CHOICE = 3;
int BATTLE = 4;
int GAME_OVER = 5;
String popUp; //Stores the text to be used in the message pop ups
float bossHealth;
int choiceOption; //Used to pick what choice event the team will encounter
int Level = 0; //Current Level
int transparency = 255; //Used for fade
int newRound; //Used for rounds system in battles. 
int quoteChoice; //Used to get a quote from array
boolean enemyAttack, teamAttack, attackNow; //Battle Variables
boolean fade, battle, makeNew, showPopUp, getStat, lose, determinNew, specialAttack, levelUp, block;
boolean ignore, rob, help, drink, inspect, info, fight, handover, examine, rest, heal, chase; //Booleans used for the choices
PImage background; //Variable to store the background image
PImage message; //Image of the message box
PImage heart; //Stores the heart of the player for minigame
Members selectedCharacter; //Currently selected  team member
Enemy selectedEnemy; //Currently selected Enemy
ArrayList<Buttons> menu; //Array of buttons for the menus, changes depending on the game state
ArrayList<Enemy> opp= new ArrayList<Enemy>();  //Arraylist to store enemy
ArrayList<Members> team;  //Arraylis to store team members
PVector[] ePlaces = new PVector[4]; //Array to store enemy positions
ArrayList<Integer> choices; //Stores the random quotes
ArrayList<String> standbyQuotes; //Stores the random quotes
ArrayList<String> battleQuotes; //Stores the random quotes
ArrayList<String> wonQuotes; //Stores the random quotes
ArrayList<String> enemyNames; //Used to store list of enemy names

//Used for the mini game
int heartX = 775, heartY = 450; //Initial starting position
int bossAttack;
boolean up, down, left, right, minigameGo;
ArrayList<EnemyAttack> eAttack = new ArrayList<EnemyAttack>(); //Contains all the balls
int time = millis();
int timer = millis();
int hitTimer = millis();

void setup() {     
  size(1600, 900); 
  PFont font = createFont("SFPixelate.ttf", 24);
  textFont(font);
  restart();
}

void restart() {
  message = loadImage("TextBox.png");
  background = loadImage("Title.png");
  choices = new ArrayList<Integer>();
  standbyQuotes = new ArrayList<String>(); 
  battleQuotes = new ArrayList<String>();
  wonQuotes = new ArrayList<String>(); 
  enemyNames = new ArrayList<String>();
  //Creates each member of the party
  team  = new ArrayList<Members>();
  team.add(new Members("Mage", new PVector(400, 500)));
  team.add(new Members("Assassin", new PVector(225, 550)));
  team.add(new Members("Warrior", new PVector(575, 550)));
  team.add(new Members("Archer", new PVector(50, 500)));

  //Setups up the bosses health
  for (Members m : team) 
    bossHealth += m.maxHealth;

  //Used for the choices
  for (int i = 0; i < 6; i++)
    choices.add(i);   

  //Creates the array of enemy positions
  ePlaces[0] = new PVector(850, 550);
  ePlaces[1] = new PVector(1025, 500);
  ePlaces[2] = new PVector(1200, 550);
  ePlaces[3] = new PVector(1375, 500);   
  //All the Standby Quotes
  standbyQuotes.add("The night feels never-ending...");
  standbyQuotes.add("Nothing appears to be around so your team take this moment as a chance to breathe and prepare for what lie up ahead...");
  standbyQuotes.add("Although you appear to be all alone, you can't help but feel like you are being watched...");
  standbyQuotes.add("The forest is dead silent. Like it's holding its breath in anticipation for what will come next... ");
  //All Battle Quotes
  battleQuotes.add("As you turn a corner you walk right into a group of bandits who look like they have been waiting for for. The team gets ready for battle...");
  battleQuotes.add("You see bandits emerging from the woods! 'Sorry, nothing personal' one shouts as the begin their assult...");
  battleQuotes.add("You see a group of bandits running towards you. You hear one of them shout 'We finally found you, prepare to die!' The team readys their weapons...");
  battleQuotes.add("Up ahead are a group of bandits. The team tries to sneak around them but snaping of braches alerts the group to your presense. Looks like you will have to fight your way out...");
  //Won Battle
  wonQuotes.add("Another battle fought. Another battle won...");
  wonQuotes.add("You live to fight another battle...");
  wonQuotes.add("Hopefully one of many more victories to come...");
  wonQuotes.add("Perhaps there is hope after all...");
  //All the enemy names
  enemyNames.add("Boss"); 
  enemyNames.add("Bandit1");
  enemyNames.add("Bandit2");
  enemyNames.add("Bandit3");
  enemyNames.add("Bandit4");
}

void draw() {
  image(background, 0, 0);
  if (MODE == MENU) {
    doMenu();
  } else if (MODE == INFO) {
    menu = new ArrayList<Buttons>();
    menu.add(new Buttons("General", 50, 765));
    menu.add(new Buttons("Combat", 465, 765));
    menu.add(new Buttons("Choices", 860, 765));
    menu.add(new Buttons("Return", 1230, 765));
  } else if (MODE == GAME) {
    doGame();
  } else if (MODE == CHOICE) {
    showPopUp = true;
    menu = new ArrayList<Buttons>();
    if (choiceOption == 1) {
      menu.add(new Buttons("Ignore", 80, 765));
      menu.add(new Buttons("Rob", 650, 765));
      menu.add(new Buttons("Help", 1250, 765));
    } else if (choiceOption == 2) {
      menu.add(new Buttons("Ignore", 80, 765));
      menu.add(new Buttons("Inspect", 650, 765));
      menu.add(new Buttons("Drink", 1250, 765));
    } else if (choiceOption == 3) {
      menu.add(new Buttons("Handover", 80, 765));
      menu.add(new Buttons("Fight", 1250, 765));
    } else if (choiceOption == 4) {
      menu.add(new Buttons("Ignore", 80, 765));
      menu.add(new Buttons("Fight", 1250, 765));
    } else if (choiceOption == 5) {
      menu.add(new Buttons("Ignore", 80, 765));
      menu.add(new Buttons("Examine", 1250, 765));
    } else if (choiceOption == 6) {
      menu.add(new Buttons("Ignore", 80, 765));
      menu.add(new Buttons("Heal", 1250, 765));
    }
  } else if (MODE == BATTLE) { 
    if (showPopUp) {
    } else {
      if (minigameGo) {
        doMiniGame();
      } else {
        menu = new ArrayList<Buttons>();
        menu.add(new Buttons("Attack", 50, 765));
        menu.add(new Buttons("Block", 465, 765));
        menu.add(new Buttons("Special", 860, 765));
        menu.add(new Buttons("Stats", 1230, 765));
        doBattle();
        timer = millis();
      }
    }
  } else if (MODE == GAME_OVER) {
    if (millis() > timer + 2000) {
      background = loadImage("Win.png");
      if (lose) {
        text("YOU LOSE", 750, 500);
      } else 
      text("The Kingdom has Been Saved", 600, 100);       
      menu = new ArrayList<Buttons>();
      menu.add(new Buttons("Restart", width/2-150, 300));
      menu.add(new Buttons("Return", width/2-150, 500)); 
      menu.add(new Buttons("Quit", width/2-150, 700));
    }
  }
  if (team.size() != 0 && minigameGo != true) {
    for (Members m : team) 
      m.drawChar();
  }
  if (opp.size() != 0 && minigameGo != true) {
    for (Enemy e : opp) 
      e.drawEnemy();
  }
  if (showPopUp && MODE != GAME_OVER) {
    drawPopUp();
    if ( MODE != CHOICE && MODE != INFO) 
      menu.add(new Buttons("Ok", 660, 565));
  }
}

void doMenu() {    
  tint(255, 255, 255, transparency);
  background(0);
  if (transparency > 0) 
    transparency -= 5;
  tint(255, 255, 255, 255-transparency);
  image(background, 0, 0);
  if (transparency == 0) {
    menu = new ArrayList<Buttons>();
    menu.add(new Buttons("Begin", width/2-150, 400));
    menu.add(new Buttons("Info", width/2-150, 575));
    menu.add(new Buttons("Quit", width/2-150, 750));
  }
}

void doGame() { 
  if (Level == 3 || Level == 4) 
    background = loadImage("Lake.png");
  else 
  background = loadImage("Forest.png");
  if (makeNew) 
    nextLevel(); 
  fill(255);
  text("Level: " + Level, 750, 50);
  menu = new ArrayList<Buttons>();
  menu.add(new Buttons("Stats", 80, 765));
  menu.add(new Buttons("Proceed", 1250, 765));
}

void nextLevel() {
  getStat = false;
  if (selectedCharacter != null){
    selectedCharacter.selected = false;
    selectedCharacter = null;
  }  
  if (Level == 7) {
    //Boss Level
    background = loadImage("Final.png");
    opp = new ArrayList<Enemy>();
    opp.add(new Enemy(new PVector(1375, 450), enemyNames.get(0)));
    newRound = team.size() + opp.size();
    for (Members m : team) 
      m.special = true;    
    selectedCharacter = null;
    selectedEnemy = null;
    popUp = "You can see the castle up ahead. However in front of you is the leader of the bandits. 'So you're the ones my spies have told me about. Then it is about time a deal with you myself!'. He draws his weapon and locks eyes, ready to fight. You can see bandits in the trees, no doubt ready to jump in and help. Defeat him and any reinforcements and reclaim your home.";
    showPopUp = true;
    MODE = BATTLE;
  } else {
    //Get a random int and decide whether enemy will spawn
    int chance = (int) random(1, 11);
    if (chance <=  5) {      
      int enemyAmt = (int) random(1, 5);
      opp = new ArrayList<Enemy>();
      for (int i = 0; i<enemyAmt; i++)
        opp.add(new Enemy(ePlaces[i], enemyNames.get((int) random (1, 5))));      
      newRound = team.size() + opp.size();
      for (Members m : team) 
        m.special = true;      
      selectedCharacter = null;
      selectedEnemy = null;
      MODE = BATTLE;
      showPopUp = true;
      popUp = battleQuotes.get((int) random (0, battleQuotes.size()));
    } else {
      //Otherwise no battle, but there may be a choice
      chance = (int) random(1, 11);
      if (chance <= 5) {
        int temp = (int) random(0, choices.size());
        while (choices.get(temp) == null) {
          temp = (int) random(0, choices.size());
        }
        choiceOption = choices.get(temp);
        choices.remove(temp);
        MODE = CHOICE;
      } else {
        int q = (int) random(0, standbyQuotes.size());
        popUp = standbyQuotes.get(q);
        standbyQuotes.remove(q);
        MODE = GAME;
        showPopUp = true;
      }
    }
  }  
  makeNew = false;
}

void drawPopUp() {
  image(message, 475, 75);
  fill(255);
  if ( getStat && selectedCharacter != null) {  
    //Get Stats
    popUp = "              " + selectedCharacter.name + "\n\n\nHealth: " + selectedCharacter.currentHealth + " / " + selectedCharacter.maxHealth + "\n\n\nAttack: " + selectedCharacter.attack+ "\n\n\nDefense: " + selectedCharacter.defense+"\n\n\nSpeed: " + selectedCharacter.speed+"" ;
  } else if (levelUp) {
    //Character Leveled Up
    popUp = "          " + selectedCharacter.name + " Leveled Up!\n\n\nMax Health: " + selectedCharacter.oldHealth + " -> " + selectedCharacter.maxHealth + "\n\n\nAttack: " + selectedCharacter.oldAttack + " -> " + selectedCharacter.attack + "\n\n\nDefense: " + selectedCharacter.oldDefense + " -> " + selectedCharacter.defense +"\n\n\nSpeed: " + selectedCharacter.oldSpeed + " -> " + selectedCharacter.speed +"" ;
  } else if (Level == 1) {
    popUp = "You have recieved word that the kingdom has been overtaken by some unknow force. You must get through the forest and reclaim the castle. Tread carefully as no doubt the enemy knows of you arrival and there are no second chances...";
  } else if (MODE == CHOICE) {
    getStat = false;
    int sucess = (int) random(1, 11);
    if (choiceOption == 1) {
      popUp = "While the team are contemplating the surounding forest, a hooded being emerges from the forest. Appearing to be quite shaken, he states that he has managed to escape from the castle and has been seeking for Heroes to help. The man appears quite fragile and must be carrying some supplies for him to have survived this long...";
      if (ignore == true) {
        popUp = "Time is precious and is something that can't be wasted here dealing with minor squabbles. The team keep on walking as the man keeps on running the other way...";
        MODE = GAME;
        ignore = false;
      } else if (rob == true) {
        if (sucess <= 5) {
          popUp = "One of the team grabs the man and explain to him that whatever he just ran from is nothing compared to him and to hand over all that he has. Speechless and shaken the man hands over " + team.size() + " healing potions and as soon as he is released, runs off into the night. The team is fully healed, greatful for the mans generous 'donation' to the cause.";
          for (Members m : team) 
            m.currentHealth = m.maxHealth;          
          MODE = GAME;
        } else {
          opp = new ArrayList<Enemy>();
          for (int i = 0; i<4; i++) 
            opp.add(new Enemy(ePlaces[i], enemyNames.get((int) random (1, 5))));
          newRound = team.size() + opp.size();
          for (Members m : team) 
            m.special = true;          
          selectedCharacter = null;
          selectedEnemy = null;
          MODE = BATTLE;
          showPopUp = true;
          popUp = "Easy picking you runs through the minds of everyone in the team as someone grabs the man, only for the team to be taken aback when the man gives an evil smile and throws the team back saying\n'You shouldn't have done that'\n Then 3 hooded figures emerge and stand beside the gruel, ready to fight...";
          return;
        }
        rob = false;
      } else if (help == true) {
        if (sucess <= 5) {
          popUp = "You bandage the man up and tell him where he will be able to find a safe place until this is over. The man thanks you and teaches you a technique for defense before running off. Every ones defense has gone up by 2.";
          for (Members m : team)
            m.defense+=2;
          MODE = GAME;
        } else {
          opp = new ArrayList<Enemy>();
          for (int i = 0; i<4; i++) 
            opp.add(new Enemy(ePlaces[i], enemyNames.get((int) random (1, 5))));
          newRound = team.size() + opp.size();
          for (Members m : team)
            m.special = true;
          selectedCharacter = null;
          selectedEnemy = null;
          MODE = BATTLE;
          showPopUp = true;
          popUp = "You heal the man when suddenly he smiles and knocks one of the team members back. Suddenly three more bandits emerge from the shadows. It's a trap!";
          MODE = BATTLE;
        }
      }
    } else if (choiceOption == 2) {
      popUp = "You see a small lake, just noticable  through the tree. You feel a sudden urge to investigate this mysterious lake, as you feel as though you can hear it calling out to you and your team...";
      if (ignore == true) {
        popUp = "You shake of the urge and continue on your way, however you can't help but wonder what might have been...";
        MODE = GAME;
      } else if (inspect == true) {
        if (sucess <= 5) {
          popUp = "You stare into the seemingly bottemless lake, to be greated by the faces of you and your comrades, empowering you and solidifying your reason to fight. All stats went up for each player!";
          for (Members m : team) {
            int healthTemp = (int) random(1, 4);
            m.maxHealth += healthTemp;
            m.currentHealth += healthTemp;
            m.attack += (int) random(1, 4);
            m.defense += (int) random(1, 4);
            m.speed += (int) random(1, 4);
          }
          MODE = GAME;
        } else {
          popUp = "You stare into the seemingly bottemless lake, to be greated by the faces of you and your comrades, however there seems to be something off about the reflection before you, dark shadows swril around them and each reflection has a twisted and menacing smile. Suddenly the reflections start to rise from the lake and begin an assult!";
          opp = new ArrayList<Enemy>();
          int i = 0;
          for (Members m : team) {
            opp.add(new Enemy(ePlaces[i], "Dark" + m.name));   
            i++;
          }
          newRound = team.size() + opp.size();
          for (Members m : team) 
            m.special = true;          
          selectedCharacter = null;
          selectedEnemy = null;
          MODE = BATTLE;
        }
        inspect = false;
      } else if (drink == true) {
        if (sucess <= 5) {
          popUp = "Following the urge, your team drink from the lake, only for each member to kneel over in agony as the liquid passes through each member, feeling as though their insides are being torn apart. After some time the pain goes away, but not without leaving a lasting scar...";
          for (Members m : team) {
            int lossHealth = (int) random (1-4);
            m.maxHealth -= lossHealth;
            if (m.currentHealth > m.maxHealth) 
              m.currentHealth = m.maxHealth;
          }
          MODE = GAME;
        } else if (sucess <= 9) {
          popUp = "Following the urge, your team drink from the lake, with each member feeling revitalised and ready to keep on moving. All the team members max health has increased.";
          for (Members m : team) {
            int gainHealth = (int) random (1-4);
            m.maxHealth += gainHealth;
            m.currentHealth += m.maxHealth;
          }
          MODE = GAME;
        } else {
          popUp = "Following the urge, your team drink from the lake, each member looks at each other waiting for something to happen....but nothing happens. Looks like that was just a waste of time";
          MODE = GAME;
        }
        drink = false;
      }
    } else if (choiceOption == 3) {
      popUp = "The team is surrounded by a group of slave traders. They tell the team to hand over a member of the team to give the others their freedom. Does the team fight or draw straws?";
      if (fight) {
        popUp = "The team would never hand one of their over to scum like them, and get ready for battle!";
        opp = new ArrayList<Enemy>();
        for (int i = 0; i < 4; i++) {
          opp.add(new Enemy(ePlaces[i], enemyNames.get((int) random (1, 5))));
        }   
        newRound = team.size() + opp.size();
        for (Members m : team) {
          m.special = true;
        }
        selectedCharacter = null;
        selectedEnemy = null;
        MODE = BATTLE;
      } else if (handover) {
        selectedCharacter = team.get((int) random(0, team.size()));
        popUp = "The team draws straws and the " + selectedCharacter.name + " is chosen by fate. The team watches as the slave traders tie up your former team member and drag them off into the night...";
        team.remove(selectedCharacter);
        selectedCharacter = null;
        if (team.size() == 0) {
          lose = true;
          timer = millis();
          MODE = GAME_OVER;
        } else {
          MODE = GAME;
        }
      }
    } else if (choiceOption == 4) {
      popUp = "The team sees a small group of people being harrassed by bandits, should the heroes step in? ";
      if (ignore) {
        popUp = "Natural selection. The team keeps on walking...";
        MODE = GAME;
      } else if (fight) {
        popUp = "Not on your watch as the team charges at the enemy, who turn and do the same!";
        opp = new ArrayList<Enemy>();
        for (int i = 0; i < 4; i++) {
          opp.add(new Enemy(ePlaces[i], enemyNames.get((int) random (1, 5))));
        }   
        newRound = team.size() + opp.size();
        for (Members m : team) {
          m.special = true;
        }
        selectedCharacter = null;
        selectedEnemy = null;
        MODE = BATTLE;
      }
    } else if (choiceOption == 5) {
      popUp = "The team stumbles upon what appears to be a small ritual site. Strange unknown markings and runes litter the area and in the center lies an alter, with a book placed in the middle. What does the team do?";
      if (ignore) {
        popUp = "This is obviously a bad idea. Best to leave while you have control over the situation.";
        MODE = GAME;
      } else if (examine) {
        if (sucess <= 5) {
          popUp = "You open the book and gaze at the what would appear to be ancient symbols. The longer you stare the clearer these symbols become. allowing them to be read. Suddenly there is a burst of light from the book and it engulfs the team! Then everything becomes dark and the book looks to have disappeared, but it seems to have left a gift. Each team member attack has gone up by 2";
          for (Members m : team) {
            m.attack += 2;
          }
          MODE = GAME;
        } else {
          popUp = "One of the team goes to touch the book, when suddenly it glows red. The markings and symbols begin to light up red in unison. The team can't look away, and with the lights getting brighter it begins to burn! Suddenly there is a burst of light from the book and it engulfs the team! Then everything becomes dark and the book looks to have disappeared, but not without taking a bit of each member with it. Each member loses 2 health from their max health!";
          for (Members m : team) {
            m.maxHealth -= 2;
            if (m.currentHealth > m.maxHealth) {
              m.currentHealth = m.maxHealth;
            }
          }
        }
      }
    } else if (choiceOption == 6) {
      popUp = "You see a group of people in the distance. Juding by their stance they would seem to be hurt. Do you go and help?";
      if (ignore) {
        popUp = "You're sure that at least one of them will know first aid and you decide that it would be better to just keep walking...";
        MODE = GAME;
      } else if (heal) {
        if (sucess <= 5) {
          popUp = "Initially skeptical of you, the group is grateful that you came and helped out. It turns out that they are skilled fighters and give you some valuable tips for battle. The teams attack goes up.";
          for (Members m : team) {
            m.attack += 2;
          }
          MODE = GAME;
        } else {
          popUp = "You make your way over but as get close the 'hurt' group turn and smile and pull out their weapons. It's a trap!";
          opp = new ArrayList<Enemy>();
          for (int i = 0; i < 4; i++) {
            opp.add(new Enemy(ePlaces[i], enemyNames.get((int) random (1, 5))));
          }   
          newRound = team.size() + opp.size();
          for (Members m : team) {
            m.special = true;
          }
          selectedCharacter = null;
          selectedEnemy = null;
          MODE = BATTLE;
        }
      }
    }
  } 
  text(popUp, 525, 125, message.width-75, message.height-75);
}

void doBattle() {
  //If it is the start of a new round  reset can attack variable
  if (newRound == team.size() + opp.size()) {
    for (Members m : team) {
      m.CanAttack = true;
    }
    for (Enemy e : opp) {
      e.CanAttack = true;
    }
    newRound = 0;
    determinNew = true;
  }
  //Checks if a new character can attack
  if (determinNew) 
    determinAttacker();  
  if (enemyAttack) {
    fill(255);
    text("Enemies Turn", 1200, 100);
    if (selectedEnemy.name.equals("Boss") && opp.size() == 1) {
      for (int i = 0; i < 3; i++) {
        opp.add(new Enemy(ePlaces[i], enemyNames.get((int) random (1, 5))));
      }
      selectedCharacter.selected = false;
      selectedCharacter = null;
      selectedEnemy.CanAttack = false;
      selectedEnemy.selected = false;
      selectedEnemy = null;
      newRound++;
      enemyAttack = false;
      determinNew = true;
    } else if (millis() > time + 3000) {
      time = millis();
      minigameGo = true;
    }
  } else if (teamAttack) { 
    fill(255);
    text("Players Turn", 200, 100);
    //Wait until player wishes to attack
    if (attackNow) {
      boolean missed = false;
      if (specialAttack) {
        selectedCharacter.doSpecial();
        text("SPECIAL", 800, 100);
        selectedCharacter.special = false;
        specialAttack = false;
      } else if (block) {
        selectedCharacter.canBlock = true;
        selectedCharacter.tempDefense = selectedCharacter.defense;
        selectedEnemy = null;
      } else {
        int attackChance = (int) random(1, 11);
        if ( attackChance <= 2 ) {
          text("MISSED", 800, 100);
          missed = true;
        } else if (attackChance > 2 && attackChance <= 9) {
          selectedEnemy.currentHealth -= selectedCharacter.attack;
          text("HIT", 800, 100);
        } else {
          selectedEnemy.currentHealth -= selectedCharacter.attack * 2;
          text("CRIT", 800, 100);
        }
      }
      
      //Used to show if the attack hit
      if (selectedEnemy != null && !missed) {
        selectedEnemy.hit = true;
      }
      hitTimer = millis();
      //Checks to see if enemy died   
      for (Enemy e : opp) {
        if (e.currentHealth <= 0) {    
          if (e.CanAttack == false) {
            newRound--;
          }
          selectedCharacter.killCount++;
          if (selectedCharacter.levelUp()) {
            showPopUp = true;
            levelUp = true;
          }
          opp.remove(e);          
          break;
        } else {
          e.selected = false;
        }
      }
      selectedEnemy = null;
      if (!levelUp) {        
        selectedCharacter.CanAttack = false;  
        selectedCharacter.selected = false;  
        selectedCharacter = null;
      }
      block = false;
      attackNow = false;
      teamAttack = false;
      determinNew = true;
      newRound++;
    }
  }
  //Check if the opponents run out of characters
  if (opp.size() == 0) {   
    if (Level == 7) {
      lose = false;
      timer = millis();
      MODE = GAME_OVER;
    } else {
      popUp = wonQuotes.get((int) random(0, 4));
      showPopUp = true;
      MODE = GAME;
    }
  }
}

void determinAttacker() {
  while (millis() < hitTimer + 1500) {
  }
  for (Members m : team) {
    if (m.CanAttack == true) {
      if (selectedCharacter == null) {
        selectedCharacter = m;
      } else if (m.speed > selectedCharacter.speed) {
        selectedCharacter = m;
      }
    }
  }
  for (Enemy e : opp) {
    e.hit = false;
    if (e.CanAttack == true) {
      if (selectedEnemy == null) {
        selectedEnemy = e;
      } else if (e.speed > selectedEnemy.speed) {
        selectedEnemy = e;
      }
    }
  }
  if (selectedCharacter == null) {
    enemyAttack = true;
  } else if (selectedEnemy == null) {
    teamAttack = true;
  } else {
    if (selectedCharacter.speed >= selectedEnemy.speed) {
      teamAttack = true;
    } else {
      enemyAttack = true;
    }
  }
  if (teamAttack == true) {
    selectedCharacter.selected = true;
    selectedEnemy = null;
  } else if (enemyAttack == true) {
    selectedEnemy.selected = true;
    if (selectedEnemy.name.equals("Boss")) {
      bossAttack = (int) random(1, 5);
    }
    selectedCharacter = team.get((int) random(0, team.size()));
    selectedCharacter.selected = true;
    time = millis();
  }  
  determinNew = false;
}

void doMiniGame() {
  //Only draw the selected characters
  selectedCharacter.drawChar();  
  selectedEnemy.drawEnemy();
  //Draw the minigame area
  noStroke();
  fill(255);
  rect(480, 100, 600, 600);
  fill(0);
  rect(500, 120, 560, 560);
  if (selectedCharacter.canBlock) 
    heart = loadImage("HeartBlock.png");
  else 
  heart = loadImage("Heart.png");
  if (up && heartX > 120) 
    heartY-=5;   
  if (down && heartY + heart.height < 680) 
    heartY+=5;  
  if (left && heartX > 500) 
    heartX-=5;   
  if (right  && heartX + heart.width < 1060) 
    heartX+=5;  
  image(heart, heartX, heartY);
  fill(255);
  //Determin what attack will play
  if (bossAttack == 1 || selectedEnemy.name.equals("Bandit1") || selectedEnemy.name.equals("DarkMage")) {
    if (millis() > time + 500) {
      int count = 0;
      while (count < (int) random(1, 11)) {
        eAttack.add(new EnemyAttack(new PVector ((int) random(550, 1000), 135), 30));
        count++;
      }    
      time = millis();
    }
  } else if (bossAttack == 2 || selectedEnemy.name.equals("Bandit2") || selectedEnemy.name.equals("DarkArcher")) {
    if (millis() > time + 500) {
      int count = 0;
      while (count < (int) random(1, 11)) {
        eAttack.add(new EnemyAttack(new PVector (1060, (int) random(135, 665)), 30));
        count++;
      }    
      time = millis();
    }
  } else if (bossAttack == 3 || selectedEnemy.name.equals("Bandit3") || selectedEnemy.name.equals("DarkWarrior")) {
    stroke(255);
    if (millis() > time + 500) {
      int side = (int) random(1, 11);
      if (side <=5) {
        eAttack.add(new EnemyAttack(new PVector(500, 120), (int) random(680, 880)));
      } else {
        eAttack.add(new EnemyAttack(new PVector(1060, 120), (int) random(680, 880)));
      }
      time = millis();
    }
  } else if (bossAttack == 4 || selectedEnemy.name.equals("Bandit4") || selectedEnemy.name.equals("DarkAssassin")) {
    stroke(255);
    if (millis() > time + 500) {
      int side = (int) random(1, 11);
      if (side <=5) {
        eAttack.add(new EnemyAttack(new PVector(1060, 120), (int) random(300, 400)));
      } else {
        eAttack.add(new EnemyAttack(new PVector(1060, 680), (int) random(300, 400)));
      }
      time = millis();
    }
  }
  if (eAttack.size() > 0) {
    for (EnemyAttack b : eAttack) {        
      b.move();
      if (b.pos.y >= 680) {
        eAttack.remove(b);
        break;
      } else if (b.pos.x <= 500) {
        eAttack.remove(b);
        break;
      }
      if (b.collide()) {
        if (!selectedCharacter.canBlock || selectedCharacter.hit == true) {
          selectedCharacter.currentHealth -= selectedEnemy.attack;
          selectedCharacter.hit = true;
          hitTimer = millis();
          eAttack.remove(b);
          break;
        }         
        if (selectedCharacter.canBlock) {
          selectedCharacter.tempDefense -= selectedEnemy.attack;
          if (selectedCharacter.tempDefense <= 0) {
            selectedCharacter.canBlock = false;
          }
        }
      }
    }
  }
  noStroke();
  if (millis() > hitTimer + 1000) {
    selectedCharacter.hit = false;
  } 

  if (selectedCharacter.currentHealth <= 0) {
    selectedCharacter.selected = false;
    if (selectedCharacter.CanAttack == false) {
      newRound--;
    }
    team.remove(selectedCharacter);      
    timer -= 7000;
  }
  if (millis() > timer + 7000) {
    //Reset minigame for next time
    eAttack = new ArrayList<EnemyAttack>();
    heartX = 775;
    heartY = 450;
    selectedCharacter.hit = false;
    selectedCharacter.selected = false;
    selectedCharacter = null;
    selectedEnemy.CanAttack = false;
    selectedEnemy.selected = false;    
    selectedEnemy = null;
    newRound++;
    enemyAttack = false;
    determinNew = true;
    minigameGo = false;
  }
  if (team.size() == 0) {
    lose = true;
    timer = millis();
    MODE = GAME_OVER;
  }
}

void mouseReleased() {
  PVector mPos = new PVector(mouseX, mouseY); //Get the current mouse position
  if (menu == null || enemyAttack) {  //Stops the program throwing nullpointer if you click during transitions
    return;
  } 
  for (int i = 0; i < menu.size(); i++) {
    String selectedButton = menu.get(i).buttonPressed(mPos);    
    if (selectedButton.equals("Begin")) {
      MODE = GAME;
      showPopUp = true;
      Level = 1;
      return;
    } else if (selectedButton.equals("Info")) {
      MODE = INFO;
      showPopUp = true;
      popUp = "You must get this team of heroes to the castle by travelling through the outer forest. Monsters may attack, and you may need to make tough choices.\n -The most important thing to remember is that if a charcater loses all their health.";
      return;
    } else if (selectedButton.equals("General")) {
      showPopUp = true;
      popUp = "You must get this team of heroes to the castle by travelling through the outer forest. Monsters may attack, and you may need to make tough choices.\n -The most important thing to remember is that if a charcater loses all their health.";
      return;
    } else if (selectedButton.equals("Combat")) {
      showPopUp = true;
      popUp = "-When battling you may attack or block on your turn. If you block your defense will act as a shield when that character is being attacked. If it breaks the character will start to take damage.\n-Every character has a special ability that may be used once per battle. Use this wisely as they may be able to get you out of messy situations\n-Mage can heal everyone on the team by whatever mages attack is\n-Assassin gets a guarenteed critical hit\n-Warrior will attack 2 times but the enemy targets are random\n-Archer will hit everyone on the field";
      return;
    } else if (selectedButton.equals("Choices")) {
      showPopUp = true;
      popUp = "-There is a chance that you may have to make choices during the game. They may offer great rewards, or bring about your defeat. Choose wisely.";
      return;
    } else if (selectedButton.equals("Quit")) {
      exit();
    } else if (selectedButton.equals("Restart")) {
      restart();
      MODE = GAME;
      showPopUp = true;
      Level = 1;
      return;
    } else if (selectedButton.equals("Return")) {
      showPopUp = false;
      MODE = MENU;
      return;
    } else if (selectedButton.equals("Proceed")) {
      Level++;
      makeNew = true;
      return;
    } else if (selectedButton.equals("Ok")) {
      showPopUp = false;
      if (levelUp) {
        levelUp = false;
        selectedCharacter.CanAttack = false;  
        selectedCharacter.selected = false;  
        selectedCharacter = null;
      }
      return;
    } else if (selectedButton.equals("Stats")) {
      if (selectedCharacter !=  null) {
        showPopUp = true;
        getStat = true;
        return;
      }
    } else if (selectedButton.equals("Attack")) {
      if (selectedEnemy != null) {
        attackNow = true;
      }
      return;
    } else if (selectedButton.equals("Block")) {
      attackNow = true;
      block = true;
      return;
    } else if (selectedButton.equals("Special")) {
      if (selectedCharacter.special == true && (selectedCharacter.name.equals("Mage") || selectedCharacter.name.equals("Archer")  || selectedCharacter.name.equals("Warrior"))) {
        specialAttack = true;
        attackNow = true;
      } else if (selectedEnemy != null && selectedCharacter.special == true) {
        specialAttack = true;
        attackNow = true;
      }
      return;
    } else if (selectedButton.equals("Ignore")) {
      ignore = true;
      return;
    } else if (selectedButton.equals("Rob")) {
      rob = true;
      return;
    } else if (selectedButton.equals("Help")) {
      help = true;
      return;
    } else if (selectedButton.equals("Inspect")) {
      inspect = true;
      return;
    } else if (selectedButton.equals("Drink")) {
      drink = true;
      return;
    } else if (selectedButton.equals("Heal")) {
      heal = true;
      return;
    } else if (selectedButton.equals("Examine")) {
      examine = true;
      return;
    } else if (selectedButton.equals("Fight")) {
      fight = true;
      return;
    } else if (selectedButton.equals("Handover")) {
      handover = true;
      return;
    } else if (selectedButton.equals("Rest")) {
      rest = true;
      return;
    }
  }
  //Used to select team players
  if ((MODE != BATTLE) && (MODE != MENU) && (MODE != INFO)) {
    for (int i = 0; i < team.size(); i++) {   
      if (mPos.x > team.get(i).pos.x && mPos.x < team.get(i).pos.x + team.get(i).shown[i].width && mPos.y > team.get(i).pos.y && mPos.y < team.get(i).pos.y + team.get(i).shown[i].height ) {
        selectedCharacter = team.get(i);
        selectedCharacter.selected = true;
      } else {
        team.get(i).selected = false;
      }
    }
    //Used to selected enemy players
  } else if (teamAttack) {
    for (int e = 0; e < opp.size(); e++) {
      if (mPos.x > opp.get(e).pos.x && mPos.x < opp.get(e).pos.x + opp.get(e).shown[e].width && mPos.y > opp.get(e).pos.y && mPos.y < opp.get(e).pos.y + opp.get(e).shown[e].height ) {
        selectedEnemy = opp.get(e);
        selectedEnemy.selected = true;
      } else {
        opp.get(e).selected = false;
      }
    }
  }
}

//Both keyPressed and keyReleased are only used for mini game whe moving the Players icon
void keyPressed() {
  if (key == 'w' || key == 'W') 
    up = true;
  if (key == 'a' || key == 'A') 
    left = true;
  if (key == 's' || key == 'S') 
    down = true;
  if (key == 'd' || key == 'D') 
    right = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W')
    up = false;
  if (key == 'a' || key == 'A') 
    left = false;
  if (key == 's' || key == 'S') 
    down = false;
  if (key == 'd' || key == 'D') 
    right = false;
}