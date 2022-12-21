function copyTextElement(element) {
  const text = element.innerText;

  const temp = document.createElement("textarea");
  temp.style.position = "absolute";
  temp.style.left = "-9999px";
  temp.textContent = text;
  document.body.appendChild(temp);

  const selection = window.getSelection();
  const range = document.createRange();
  range.selectNodeContents(temp);
  selection.removeAllRanges();
  selection.addRange(range);

  document.execCommand("copy");

  document.body.removeChild(temp);
}