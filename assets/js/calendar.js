document.addEventListener('DOMContentLoaded', function() {
  var select = document.getElementById('calendar-select');
  if (!select) return;

  function filterByMonth() {
    var selectedMonth = select.value;
    var items = document.querySelectorAll('.calendar-item');

    items.forEach(function(item) {
      var itemMonth = item.dataset.month;
      if (selectedMonth === '' || itemMonth === selectedMonth) {
        item.style.display = '';
      } else {
        item.style.display = 'none';
      }
    });
  }

  select.addEventListener('change', filterByMonth);
  filterByMonth();
});
