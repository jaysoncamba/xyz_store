import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static values = { url: String }
  static targets = ['input']

  connect() {
    this.format = "abc"
  }

  search(event) {
    event.preventDefault()
    this.validate()
  }

  validFormat() {
    return /(ISBN[-]*(1[03])*[ ]*(: ){0,1})*(([0-9Xx][- ]*){13}|([0-9Xx][- ]*){10})/.test(this.inputTarget.value)
  }

  validate() {
    if(this.validFormat()) {
    } else {
      alert("Invalid ISBN 10/13 Format")
    }
  }
}
