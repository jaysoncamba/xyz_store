import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['content']

  connect() {
    // This should remember the original page before the search.
    this.indexContent = this.contentTarget.innerHTML
    window.addEventListener("search:completed", this.updateContent.bind(this));
  }

  disconnect() {
    // Clean up event listeners to prevent memory leaks
    window.removeEventListener("search:completed", this.updateContent.bind(this));
  }

  updateContent(event) {
    const { type, attributes } = event.detail
    if((attributes !== undefined && type == "error")) {
      this.contentTarget.innerHTML = this.errorTemplate(attributes)
    } else {
      this.contentTarget.innerHTML = this.bookTemplate(attributes)
    }
  }

  reloadIndex() {
    this.contentTarget.innerHTML = this.indexContent
  }

  errorTemplate(attribute) {
    return `
      <div class="w-full relative py-10 overflow-x-hidden sm:py-40">
        <div class="container max-w-6xl relative w-full mx-auto sm:rounded-lg sm:px-10">
          <div class="mx-auto px-5 text-center">
            <h1 class="text-indigo-900 text-3xl"> ${attribute.message} </h1>
          </div>
        </div>
      </div>
    `
  }



  bookTemplate(book)  {
    if(book == undefined || book == null) {
      return `
        <div class="w-full relative py-10 overflow-x-hidden sm:py-40">
          <div class="container max-w-6xl relative w-full mx-auto sm:rounded-lg sm:px-10">
            <div class="mx-auto px-5 text-center">
              <h1 class="text-indigo-900 text-3xl"> Not Found </h1>
            </div>
          </div>
        </div>
      `
    } else { 
      return `<h1> Book title: ${book.title} </h1>`
    }
  }
}
