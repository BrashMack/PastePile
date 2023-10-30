/*jshint esversion: 6 */

let rememberedState;

function enable(adminCheckbox) {
  adminCheckbox.checked = rememberedState;
  adminCheckbox.disabled = false;
}

function disable(adminCheckbox) {
  rememberedState = adminCheckbox.checked;
  adminCheckbox.checked = true;
  adminCheckbox.disabled = true;
}

const superuserCheckbox = document.getElementById("user_superuser");
const adminCheckbox = document.getElementById("user_admin");
if (superuserCheckbox.checked) {
  disable(adminCheckbox);
}

superuserCheckbox.addEventListener("change", (event) => {
  if (superuserCheckbox.checked) {
    disable(adminCheckbox);
  } else {
    enable(adminCheckbox);
  }
});
