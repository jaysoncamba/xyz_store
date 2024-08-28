import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['content']

  connect() {
    this.indexContent = this.contentTarget.innerHTML
    window.addEventListener("search:completed", this.updateContent.bind(this));
  }

  disconnect() {
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
      <div class="w-full relative py-10 overflow-x-hidden lg:py-20 lg:pb-40">
        <div class="container max-w-6xl relative w-full mx-auto sm:rounded-lg sm:px-10">
          <div class="mx-auto px-5">
            <h1 class="text-blue-950 text-3xl font-black"> ${attribute.message} </h1>
          </div>
        </div>
      </div>
    `
  }

  bookTemplate(book)  {
    return `
      <div class="w-full relative py-10 overflow-x-hidden lg:py-20 lg:pb-40">
        <div class="container max-w-6xl relative w-full mx-auto sm:rounded-lg sm:px-10">
          <div class="mx-auto p-5">
            <h1 class="text-blue-950 text-3xl font-black"> Search Result </h1>
          </div>
          <div class="flex lg:flex-row p-5 mx-auto flex-col">
            <div class="flex w-72 lg:mr-20 mb-4 mx-auto lg:mx-0">
              <img src="${book.image_url}">
            </div>
            <div class="flex flex-col leading-loose">
              <h2 class="font-extrabold text-2xl">${book.title}</h2>
              <div class="py-5">
                <h2 class="font-bold text-xl"> by ${book.authors} </h2>
              </div>

              <ul class="list-none">
                ${ this.render_row(book).join(" \n ") }
              </ul>
            </div>
          </div>
        </div>
      </div>
    `
  }

  render_row(book) {
    let rows = ["Edition", "Price", "ISBN 13", "ISBN 10", "Publication Year", "Publisher"].map(attribute => {
      const book_attribute = book[attribute.replace(" ", "_").toLowerCase()];
      if(book_attribute !== null) {
        return `<li class="font-bold">${attribute}: <span class="text text-indigo-500"> ${book_attribute} </span></li>`
      }
    })
    return rows.filter(value => value !== null && value !== undefined);
  }

}
