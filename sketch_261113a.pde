
ArrayList<Drop> items = new ArrayList<Drop>();

float playerX;
float playerY;
float playerSize = 35;

int score = 0;
int lives = 3;

boolean started = false;
boolean gameOver = false;

float difficulty = 1;

void setup() {
  size(800, 600);
  playerX = width / 2;
  playerY = height - 60;
}

void draw() {
  background(15, 20, 40);

  drawBackground();

  if (!started && !gameOver) {
    drawPlayer();
    drawTitle();
    return;
  }

  if (gameOver) {
    drawPlayer();
    drawGameOver();
    return;
  }

  // 마우스 위치에 따라 플레이어 이동
  playerX = constrain(mouseX, playerSize/2,
                      width - playerSize/2);

  // 점수에 따른 난이도 상승
  difficulty = min(3.0, 1 + score / 100.0);

  // 아이템 생성
  int spawnRate = max(18, 48 - score / 15);

  if (frameCount % spawnRate == 0) {
    items.add(new Drop());
  }

  // 아이템 이동 및 충돌 검사
  for (int i = items.size() - 1; i >= 0; i--) {
    Drop d = items.get(i);

    d.update();
    d.display();

    if (d.isColliding(playerX, playerY)) {

      if (d.isStar) {
        score += 10;
      } else {
        lives--;
      }

      items.remove(i);

      if (lives <= 0) {
        gameOver = true;
      }

      continue;
    }

    if (d.y > height + 30) {
      items.remove(i);
    }
  }

  drawPlayer();
  drawUI();
}

// 배경
void drawBackground() {
  noStroke();

  for (int i = 0; i < 60; i++) {
    float x = (i * 137) % width;
    float y = (i * 83) % height;

    fill(255, 150);
    ellipse(x, y, 2, 2);
  }
}

// 플레이어: 원형
void drawPlayer() {
  noStroke();
  fill(70, 180, 255);
  ellipse(playerX, playerY, playerSize, playerSize);
}

// UI
void drawUI() {
  fill(255);
  textSize(22);
  textAlign(LEFT);
  text("SCORE: " + score, 25, 35);

  textAlign(RIGHT);
  text("LIVES: " + lives, width - 25, 35);
}

// 시작 화면
void drawTitle() {
  textAlign(CENTER);

  fill(255, 220, 80);
  textSize(55);
  text("STAR CATCHER", width/2, height/2 - 70);

  fill(255);
  textSize(20);
  text("Catch stars and avoid meteors!",
       width/2, height/2);

  textSize(17);
  text("Move your mouse to control the circle",
       width/2, height/2 + 45);

  text("Press SPACE to start",
       width/2, height/2 + 90);
}

// 게임 종료 화면
void drawGameOver() {
  textAlign(CENTER);

  fill(255, 100, 110);
  textSize(50);
  text("GAME OVER", width/2, height/2 - 50);

  fill(255);
  textSize(25);
  text("Final Score: " + score,
       width/2, height/2 + 10);

  textSize(17);
  text("Press SPACE to restart",
       width/2, height/2 + 65);
}

// 키보드 입력
void keyPressed() {
  if (key == ' ') {
    if (!started && !gameOver) {
      started = true;
    } else if (gameOver) {
      resetGame();
    }
  }
}

// 재시작
void resetGame() {
  score = 0;
  lives = 3;
  difficulty = 1;

  items.clear();

  playerX = width/2;
  started = true;
  gameOver = false;
}

// 아이템 클래스
class Drop {
  float x, y;
  float speed;
  float size;

  boolean isStar;

  Drop() {
    x = random(30, width - 30);
    y = -20;

    isStar = random(1) < 0.7;

    size = isStar ? 24 : 28;
    speed = random(2, 4);
  }

  void update() {
    y += speed * difficulty;
  }

  void display() {
    noStroke();

    if (isStar) {
      // 별: 삼각형
      fill(255, 220, 70);

      triangle(
        x, y - size/2,
        x - size/2, y + size/2,
        x + size/2, y + size/2
      );

    } else {
      // 운석: 사각형
      fill(150, 160, 175);
      rectMode(CENTER);
      rect(x, y, size, size);
      rectMode(CORNER);
    }
  }

  boolean isColliding(float px, float py) {
    float distance = dist(x, y, px, py);

    return distance < (size/2 + playerSize/2);
  }
}
