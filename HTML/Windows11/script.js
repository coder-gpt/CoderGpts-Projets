/* Boot → Login */
setTimeout(() => {
  document.getElementById("boot").classList.add("hidden");
  document.getElementById("login").classList.remove("hidden");
}, 3000);

function login(){
  document.getElementById("login").classList.add("hidden");
  document.getElementById("desktop").classList.remove("hidden");
  document.documentElement.requestFullscreen();
}

/* Start Menu */
function toggleStart(){
  let m = document.getElementById("startMenu");
  m.style.display = m.style.display === "block" ? "none" : "block";
}

/* Window */
function openWindow(){
  document.getElementById("window1").style.display = "block";
}

/* Clock */
function updateClock(){
  let d = new Date();
  document.getElementById("clock").innerText =
    d.toLocaleTimeString([], {hour:'2-digit', minute:'2-digit'});
}
setInterval(updateClock,1000);
updateClock();

/* Dragging */
let dragTarget = null, offsetX = 0, offsetY = 0;

document.querySelectorAll(".titlebar").forEach(bar => {
  bar.onmousedown = e => {
    dragTarget = bar.parentElement;
    offsetX = e.clientX - dragTarget.offsetLeft;
    offsetY = e.clientY - dragTarget.offsetTop;
  };
});

document.onmousemove = e => {
  if(!dragTarget) return;
  dragTarget.style.left = e.clientX - offsetX + "px";
  dragTarget.style.top = e.clientY - offsetY + "px";
};

document.onmouseup = () => dragTarget = null;
