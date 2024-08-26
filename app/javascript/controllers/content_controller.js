import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['content']

  connect() {
    // This should remember the original page before the search.
    this.indexContent = this.contentTarget.innerHTML
    window.addEventListener("search:completed", this.updateContent.bind(this));
    window.addEventListener("search:failed", this.updateContentError.bind(this));
  }

  disconnect() {
    // Clean up event listeners to prevent memory leaks
    window.removeEventListener("search:completed", this.updateContent.bind(this));
  }

  updateContent(event) {
    const {type, attributes} = event.detail
    if(type == "error") {
      this.contentTarget.innerHTML = this.errorTemplate()
    } else {
      this.contentTarget.innerHTML = this.bookTemplate(attributes)
    }
  }

  updateContentError(event) {}

  reloadIndex() {
    this.contentTarget.innerHTML = this.indexContent
  }

  errorTemplate() {
    return `<h1> Error ISBN not Found </h1>`
  }

  bookTemplate(book)  {
    if(book == undefined || book == null) {
      return `Not Found!`
    } else { 
      return `<h1> Book title: ${book.title} </h1>`
    }
  }
}
