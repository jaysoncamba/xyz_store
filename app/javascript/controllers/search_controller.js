import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static values = { url: String }
  static targets = ['input']

  search(event) {
    event.preventDefault()
    // Checks input if it is a valid ISBN using check digit
    if(this.isValidISBN()) {
      fetch(`${this.urlValue}/${this.inputTarget.value}.json`)
      .then(response => { 
        if(response.status == 400) {
          const customEvent = new CustomEvent("search:failed", { detail: {} });
          window.dispatchEvent(customEvent)
          return;
        }
        return response.json();
      })
      .then(data => {
        const customEvent = new CustomEvent("search:completed", {
          detail: data.data
        });
        window.dispatchEvent(customEvent)
      })
      .catch(error => { })
    } else {
      alert("Invalid ISBN 10/13 Format")
    }
  }


  isValidISBN() {
    // Remove non-digit except xX for ISBN 10
    const sanitizedISBN = this.inputTarget.value.replace(/[^0-9X]/gi, '');
    switch (sanitizedISBN.length) {
      case 10:
        return this.isValidISBN10(sanitizedISBN);
      case 13:
        return this.isValidISBN13(sanitizedISBN);
      default:
        return false;
    }
  }

  isValidISBN10(isbn) {
    if(isbn.length !== 10) { return false; };
    let sum = this.calculateISBNSum(isbn, "ISBN10");
    const checkDigit = isbn[9].toUpperCase();
    const checkValue = checkDigit === 'X' ? 10 : parseInt(checkDigit, 10);
    if (isNaN(checkValue)) { return false; };
    const expectedCheckValue = (11 - (sum % 11)) % 11;
    return checkValue === expectedCheckValue;
  }

  isValidISBN13(isbn) {
    if(isbn.length !== 13) { return false; };
    let sum = this.calculateISBNSum(isbn, "ISBN13");
    const checkDigit = parseInt(isbn[12], 10);
    if (isNaN(checkDigit)) { return false; };
    const expectedCheckValue = (10 - (sum % 10)) % 10;
    return checkDigit === expectedCheckValue;
  }

  calculateISBNSum(isbn, type) {
    let sum = 0;
    for (let idx = 0; idx < isbn.length - 1; idx++) {
      const digit = parseInt(isbn[idx], 10);
      if(isNaN(digit)) { return false; }
      if(type == "ISBN10") {
        sum += digit * (10 - idx);
      } else if ( type == "ISBN13") {
        sum += digit * (idx % 2 === 0 ? 1 : 3);
      }
    }
    return sum;
  }
}
