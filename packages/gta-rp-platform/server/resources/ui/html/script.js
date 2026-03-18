window.addEventListener('message', function(event) {
    var item = event.data;
    
    if (item.show) {
        document.body.style.display = 'block';
    }
    
    if (item.action === 'update') {
        document.getElementById('content').innerText = JSON.stringify(item.data, null, 2);
    }
});

// Escape key to close
document.addEventListener('keydown', function(event) {
    if (event.keyCode === 27) {
        document.body.style.display = 'none';
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
        });
    }
});
