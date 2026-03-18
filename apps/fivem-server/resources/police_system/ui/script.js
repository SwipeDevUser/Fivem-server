// FiveM NUI Communication
const RESOURCE_NAME = 'police_system';

window.addEventListener('message', function(event) {
    var item = event.data;
    
    if (item.show) {
        document.getElementById('police-ui').style.display = 'block';
    }
});

function closeUI() {
    document.getElementById('police-ui').style.display = 'none';
    fetch(`https://${RESOURCE_NAME}/closeUI`, {
        method: 'POST',
    });
}

function cuffPlayer() {
    var playerId = document.getElementById('playerId').value;
    if (playerId) {
        fetch(`https://${RESOURCE_NAME}/cuff`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ playerId: playerId }),
        });
    }
}

function searchPlayer() {
    var playerId = document.getElementById('playerId').value;
    if (playerId) {
        fetch(`https://${RESOURCE_NAME}/search`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ playerId: playerId }),
        });
    }
}

function arrestPlayer() {
    var playerId = document.getElementById('playerId').value;
    var jailTime = document.getElementById('jailTime').value || 10;
    if (playerId) {
        fetch(`https://${RESOURCE_NAME}/arrest`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ playerId: playerId, jailTime: jailTime }),
        });
    }
}

function finePlayer() {
    var playerId = document.getElementById('playerId').value;
    var fineAmount = document.getElementById('fineAmount').value || 500;
    if (playerId) {
        fetch(`https://${RESOURCE_NAME}/fine`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ playerId: playerId, fineAmount: fineAmount }),
        });
    }
}

// Close UI on Escape key
document.addEventListener('keydown', function(event) {
    if (event.keyCode === 27) {
        closeUI();
    }
});
