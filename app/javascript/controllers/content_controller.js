import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['content']

  connect() {
    // This should remember the original page before the search.
    const indexContent = this.contentTarget.innerHtml
  }

  updateContent(bookJson) {
    if(bookJson.type == "error") {
      this.contentTarget.innerHtml = this.errorTemplate()
    } else {
      this.contentTarget.innerHtml = this.bookTemplate(bookJson)
    }
  }

  reloadIndex() {
    this.contentTarget.innerHtml = indexContent
  }

  errorTemplate() {
    return `<h1> Error ISBN not Found </h1>`
  }

  bookTemplate(bookJson)  {
    return `<h1> Book title: ${bookJson.title} </h1>`
  }

  loadingAnimation() {
    return `
    <button type="button" class="bg-indigo-500 ..." disabled>
      <svg class="animate-spin h-5 w-5 mr-3 ..." viewBox="0 0 24 24">
      </svg>
      Processing...
    </button>`
  }
}
