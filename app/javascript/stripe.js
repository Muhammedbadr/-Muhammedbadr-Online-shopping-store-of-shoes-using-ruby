// This is your test publishable API key.
var stripe = Stripe("pk_test_51QbkH6CQJZxxODPJmsclUjLLJHTOcv0fmsrILPW3DlscAWCGSeDAdOAOYPphkcbxkdahXdHCQ0Y0Rjh4zEYsS6ls00Dw5aPx1m");

// Disable the button until we have Stripe set up on the page
document.addEventListener('DOMContentLoaded', function() {
  document.querySelector("button").disabled = true;
}, false);
fetch(`/cart/create_payment_intent`, {
  method: "POST",
  headers: {
    "Content-Type": "application/json"
  },
})
  .then(function(result) {
    return result.text();
  })
  .then(function(data) {
    var elements = stripe.elements();

    var card = elements.create("card", { hidePostalCode: true});
    // Stripe injects an iframe into the DOM
    card.mount("#card-element");

    card.on("change", function (event) {
      // Disable the Pay button if there are no card details in the Element
      document.querySelector("button").disabled = event.empty;
      document.querySelector("#card-error").textContent = event.error ? event.error.message : "";
    });

    var form = document.getElementById("payment-form");
    form.addEventListener("submit", function(event) {
      event.preventDefault();
      // Complete payment when the submit button is clicked
      payWithCard(stripe, card, data);
    });
  });

// Calls stripe.confirmCardPayment
// If the card requires authentication Stripe shows a pop-up modal to
// prompt the user to enter authentication details without leaving your page.
var payWithCard = (stripe, card, clientSecret) => {
  loading(true);
  stripe.confirmCardPayment(clientSecret, {
    payment_method: {
      card: card
    }
  }).then(result => {
    if (result.error) {
      showError(result.error.message);
    } else {
      orderComplete(result.paymentIntent.id);
    }
  });
};

/* ------- UI helpers ------- */

// Shows a success message when the payment is complete
var orderComplete = function(paymentIntentId) {
  loading(false);
  document
    .querySelector(".result-message a")
    .setAttribute(
      "href",
      "https://dashboard.stripe.com/test/payments/" + paymentIntentId
    );
  document.querySelector(".result-message").classList.remove("hidden");
  document.querySelector("button").disabled = true;
};

// Show the customer the error from Stripe if their card fails to charge
var showError = function(errorMsgText) {
  loading(false);
  var errorMsg = document.querySelector("#card-error");
  errorMsg.textContent = errorMsgText;
  setTimeout(function() {
    errorMsg.textContent = "";
  }, 4000);
};

// Show a spinner on payment submission
var loading = function(isLoading) {
  if (isLoading) {
    // Disable the button and show a spinner
    document.querySelector("button").disabled = true;
    document.querySelector("#spinner").classList.remove("hidden");
    document.querySelector("#button-text").classList.add("hidden");
  } else {
    document.querySelector("button").disabled = false;
    document.querySelector("#spinner").classList.add("hidden");
    document.querySelector("#button-text").classList.remove("hidden");
  }
};