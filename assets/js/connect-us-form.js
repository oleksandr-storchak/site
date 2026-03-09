window.onload = () => {
  document.getElementById("connectUsForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const formData = new FormData(e.target);
    const email = formData.get("contactEmail");
    formData.delete("contactEmail");

    let bodyLines = [];
    formData.forEach((value, key) => {
      bodyLines.push(`${key}: ${value}`);
    });
    const body = encodeURIComponent(bodyLines.join("\n"));
    const subject = encodeURIComponent("New Connect With Us Inquiry");

    window.location.href = `mailto:${email}?subject=${subject}&body=${body}`;
    e.target.reset();
  });
};
