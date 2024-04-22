document.addEventListener('DOMContentLoaded', function() {
    var alertList = document.querySelectorAll('.alert');

    alertList.forEach(function(alert) {
        new bootstrap.Alert(alert);
    });

    alertList.forEach(function(alert) {
        alert.querySelector('.close').addEventListener('click', function() {
            var parent = this.parentNode;
            parent.classList.add('hide');
            setTimeout(function() {
                parent.classList.add('d-none');
            }, 500);
        });
    });
});
