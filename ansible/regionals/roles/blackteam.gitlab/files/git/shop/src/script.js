function selectItem(itemId) {
    var radio = document.getElementById(itemId);
    radio.checked = true;
    updateVisualIndicator(itemId);
    updatePurchaseSection();
    scrollToCouponForm();
}

function updateVisualIndicator(itemId) {
    var items = document.querySelectorAll('.item');
    items.forEach(function(item) {
        item.classList.remove('selected');
    });
    document.getElementById(itemId).parentNode.classList.add('selected');
}

function updatePurchaseSection() {
    var purchaseSection = document.getElementById("purchase-section");
    purchaseSection.style.display = "block";
}

function scrollToCouponForm() {
    var couponForm = document.getElementById("coupon-code");
    couponForm.scrollIntoView({ behavior: 'smooth', block: 'end' });
}

function showNotification(message, type) {
    var notification = document.createElement('div');
    notification.className = 'notification ' + type;
    notification.textContent = message;

    document.body.appendChild(notification);

    setTimeout(function() {
        notification.remove();
    }, 5000); // Remove the notification after 5 seconds
}

function purchase() {
    var selectedItem = document.querySelector('input[name="selectedItem"]:checked').value;
    var couponCode = document.getElementById("coupon-code").value;

    var purchaseData = {
        item: selectedItem,
        couponCode: couponCode
    };

    fetch('http://shop.rust.energy:3000/purchase', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(purchaseData),
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        console.log(data);
        showNotification("Purchase successful! Item: " + selectedItem + ", Coupon Code: " + couponCode, 'success');
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification("Error during purchase. Please try again later.", 'error');
    });
}
