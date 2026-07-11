const canvas = document.querySelector("#game");
const ctx = canvas.getContext("2d");
const focusHint = document.querySelector("#focusHint");
const directionLabel = document.querySelector("#direction");
const motionLabel = document.querySelector("#motion");

ctx.imageSmoothingEnabled = false;

const FRAME_COUNT = 6;
const FRAME_RATE = 10;
const MOVE_SPEED = 185;
const DRAW_SIZE = 144;
const directions = ["down", "up", "right", "left"];
const directionNames = { down: "下 / 正面", up: "上 / 背面", right: "右 / 侧面", left: "左 / 侧面" };
const frames = Object.fromEntries(directions.map((direction) => [direction, []]));
const keys = new Set();

const player = {
  x: canvas.width / 2,
  y: canvas.height / 2,
  facing: "down",
  frame: 0,
  animationClock: 0,
  moving: false,
};

function loadImage(path) {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve(image);
    image.onerror = reject;
    image.src = path;
  });
}

async function loadFrames() {
  await Promise.all(directions.flatMap((direction) =>
    Array.from({ length: FRAME_COUNT }, async (_, index) => {
      const number = String(index + 1).padStart(2, "0");
      frames[direction][index] = await loadImage(`assets/frames/walk_${direction}_${number}.png?v=4`);
    })
  ));
}

function inputVector() {
  const left = keys.has("KeyA") || keys.has("ArrowLeft");
  const right = keys.has("KeyD") || keys.has("ArrowRight");
  const up = keys.has("KeyW") || keys.has("ArrowUp");
  const down = keys.has("KeyS") || keys.has("ArrowDown");
  let x = Number(right) - Number(left);
  let y = Number(down) - Number(up);
  const length = Math.hypot(x, y);
  if (length > 0) {
    x /= length;
    y /= length;
  }
  return { x, y, length };
}

function chooseFacing(x, y) {
  if (Math.abs(x) > Math.abs(y)) return x > 0 ? "right" : "left";
  if (Math.abs(y) > 0) return y > 0 ? "down" : "up";
  return player.facing;
}

function update(delta) {
  const input = inputVector();
  player.moving = input.length > 0;

  if (player.moving) {
    player.facing = chooseFacing(input.x, input.y);
    player.x += input.x * MOVE_SPEED * delta;
    player.y += input.y * MOVE_SPEED * delta;
    player.animationClock += delta;
    player.frame = Math.floor(player.animationClock * FRAME_RATE) % FRAME_COUNT;
  } else {
    player.animationClock = 0;
    player.frame = 0;
  }

  const half = DRAW_SIZE * 0.25;
  player.x = Math.max(half, Math.min(canvas.width - half, player.x));
  player.y = Math.max(DRAW_SIZE * 0.45, Math.min(canvas.height - DRAW_SIZE * 0.45, player.y));

  directionLabel.textContent = `朝向：${directionNames[player.facing]}`;
  motionLabel.textContent = `状态：${player.moving ? `行走 / 第 ${player.frame + 1} 帧` : "待机"}`;
  canvas.dataset.x = player.x.toFixed(2);
  canvas.dataset.y = player.y.toFixed(2);
  canvas.dataset.facing = player.facing;
  canvas.dataset.frame = String(player.frame);
  canvas.dataset.moving = String(player.moving);
}

function drawGround() {
  ctx.fillStyle = "#27322b";
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  ctx.strokeStyle = "#344239";
  ctx.lineWidth = 1;
  const grid = 48;
  for (let x = 0; x <= canvas.width; x += grid) {
    ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, canvas.height); ctx.stroke();
  }
  for (let y = 0; y <= canvas.height; y += grid) {
    ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(canvas.width, y); ctx.stroke();
  }

  ctx.fillStyle = "#55695a";
  ctx.fillRect(48, 48, canvas.width - 96, 4);
  ctx.fillRect(48, canvas.height - 52, canvas.width - 96, 4);
  ctx.fillRect(48, 48, 4, canvas.height - 96);
  ctx.fillRect(canvas.width - 52, 48, 4, canvas.height - 96);
}

function draw() {
  drawGround();
  const image = frames[player.facing][player.frame];
  if (!image) return;
  ctx.drawImage(image, player.x - DRAW_SIZE / 2, player.y - DRAW_SIZE * 0.72, DRAW_SIZE, DRAW_SIZE);
}

let previousTime = performance.now();
function loop(time) {
  const delta = Math.min((time - previousTime) / 1000, 0.05);
  previousTime = time;
  update(delta);
  draw();
  requestAnimationFrame(loop);
}

window.addEventListener("keydown", (event) => {
  if (["KeyW", "KeyA", "KeyS", "KeyD", "ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(event.code)) {
    event.preventDefault();
    keys.add(event.code);
  }
});

window.addEventListener("keyup", (event) => keys.delete(event.code));
window.addEventListener("blur", () => keys.clear());
canvas.addEventListener("focus", () => focusHint.classList.add("hidden"));
focusHint.addEventListener("click", () => canvas.focus());

loadFrames().then(() => {
  canvas.focus();
  focusHint.classList.add("hidden");
  requestAnimationFrame(loop);

  const autoDirection = new URLSearchParams(window.location.search).get("autotest");
  const autoKeys = { down: "KeyS", up: "KeyW", right: "KeyD", left: "KeyA" };
  if (autoKeys[autoDirection]) {
    keys.add(autoKeys[autoDirection]);
    window.setTimeout(() => keys.delete(autoKeys[autoDirection]), 700);
  }
}).catch((error) => {
  focusHint.textContent = `动画帧加载失败：${error.message}`;
});
