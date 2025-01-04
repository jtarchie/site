const shuffle = (arr) => {
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * i);
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
};

const solveNQueens = (n) => {
  const solutions = [];

  function isSafe(board, row, col) {
    // Check column and diagonals for conflicts
    for (let i = 0; i < row; i++) {
      if (
        board[i] === col ||
        board[i] - i === col - row ||
        board[i] + i === col + row
      ) {
        return false;
      }
    }
    return true;
  }

  function placeQueens(row, board) {
    if (row === n) {
      // Convert board representation to x-y coordinates
      solutions.push(board.map((col, row) => ({ x: row, y: col })));
      return;
    }

    for (let col = 0; col < n; col++) {
      if (isSafe(board, row, col)) {
        board[row] = col;
        placeQueens(row + 1, board);
        board[row] = -1; // Backtrack
      }
    }
  }

  placeQueens(0, Array(n).fill(-1));
  return solutions;
};

const generateBoard = (size) => {
  const solutions = solveNQueens(size);
  const board = Array.from({ length: size }, () => Array(size).fill(null));
  const regions = size;
  const directions = [
    [1, 0], // Down
    [-1, 0], // Up
    [0, 1], // Right
    [0, -1], // Left
  ];

  // Initialize region seeds
  let queue = [];
  const solution = solutions[Math.floor(Math.random() * solutions.length)];

  for (let region = 0; region < regions; region++) {
    const { x, y } = solution[region];
    board[x][y] = region;
    queue.push([x, y, region]);
  }

  queue = shuffle(queue);

  // Grow regions from seeds
  while (queue.length) {
    const [cx, cy, region] = shuffle(queue).shift();

    for (const [dx, dy] of shuffle(directions)) {
      const nx = cx + dx;
      const ny = cy + dy;

      // Check bounds and if the cell is unoccupied
      if (
        nx >= 0 &&
        nx < size &&
        ny >= 0 &&
        ny < size &&
        board[nx][ny] === null
      ) {
        board[nx][ny] = region;
        queue.push([nx, ny, region]);
      }
    }
  }

  return board;
};

const validBoard = (board, states, classes) => {
  const boardSize = board.length;
  const isQueen = (i, j) =>
    states[i][j] % states.length === classes.findIndex((c) => c === "queen");
  let queensByColor = {};

  for (let i = 0; i < boardSize; i++) {
    for (let j = 0; j < boardSize; j++) {
      if (isQueen(i, j)) {
        // check by color
        if (queensByColor[board[i][j]] === undefined) {
          queensByColor[board[i][j]] = 0;
        }

        queensByColor[board[i][j]]++;

        if (queensByColor[board[i][j]] > 1) {
          return false;
        }

        // check row
        for (let k = 0; k < boardSize; k++) {
          if (k !== j && isQueen(i, k)) {
            return false;
          }
        }

        // check column
        for (let k = 0; k < boardSize; k++) {
          if (k !== i && isQueen(k, j)) {
            return false;
          }
        }

        // check immediate diagonals
        const immediateDiagonals = [
          [1, 1], // down-right
          [-1, -1], // up-left
          [1, -1], // down-left
          [-1, 1], // up-right
        ];

        for (const [di, dj] of immediateDiagonals) {
          const ni = i + di;
          const nj = j + dj;
          if (ni >= 0 && ni < boardSize && nj >= 0 && nj < boardSize) {
            if (isQueen(ni, nj)) {
              return false;
            }
          }
        }
      }
    }
  }

  const countQueens = Object.values(queensByColor).reduce(
    (acc, curr) => acc + curr,
    0,
  );
  return countQueens === boardSize;
};

(function () {
  const urlParams = new URLSearchParams(window.location.search);
  const boardSize = parseInt(urlParams.get("boardSize")) || 4;
  const board = generateBoard(boardSize);

  var app = document.getElementById("app");
  var colorPallette = [
    "rgb(230, 159, 0)", // Orange
    "rgb(86, 180, 233)", // Sky Blue
    "rgb(0, 158, 115)", // Bluish Green
    "rgb(240, 228, 66)", // Yellow
    "rgb(0, 114, 178)", // Blue
    "rgb(213, 94, 0)", // Vermillion
    "rgb(204, 121, 167)", // Reddish Purple
    "rgb(128, 128, 128)", // Gray
    "rgb(255, 255, 255)", // White
    "rgb(255, 182, 193)", // Light Pink
    "rgb(152, 251, 152)", // Pale Green
    "rgb(135, 206, 250)", // Light Sky Blue
    "rgb(255, 160, 122)", // Light Salmon
    "rgb(255, 228, 181)", // Moccasin
  ];
  var classes = ["empty", "cross", "queen"];
  var states = new Array(boardSize)
    .fill(0)
    .map(() => new Array(boardSize).fill(0));

  // draw the board
  for (let i = 0; i < boardSize; i++) {
    var row = document.createElement("div");
    row.classList.add("row");

    for (let j = 0; j < boardSize; j++) {
      var cell = document.createElement("div");
      cell.classList.add("cell");
      cell.style.backgroundColor = colorPallette[board[i][j]];

      cell.onclick = (event) => {
        const cell = event.target;

        cell.classList.remove(classes[states[i][j] % states.length]);
        states[i][j]++;
        cell.classList.add(classes[states[i][j] % states.length]);

        if (validBoard(board, states, classes)) {
          alert("You won!");
        }
      };

      cell.innerText = "";
      row.appendChild(cell);
    }

    app.appendChild(row);
  }
})();
