document.addEventListener("DOMContentLoaded", () => {
  const input = window.storeSearch;
  if (!input) return;

  const cards = [...window.storeItem];

  input.addEventListener("input", () => {
    const query = input.value.toLowerCase().trim();

    cards.forEach((card) => {
      const text = card.querySelector("h3")?.textContent.toLowerCase();

      card.classList.toggle("hidden", !text?.includes(query));
    });
  });
});
