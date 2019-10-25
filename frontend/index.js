function sortByName(items) {
    items.sort(function(a, b){
        if(a.name < b.name) { return -1; }
        if(a.name > b.name) { return 1; }
        return 0;
    })
    return items
}


axios.get("/temp-books.json").then((response) => {
    let books = sortByName(response.data)
    let bookShelve = document.getElementById("bookshelve")
    books.forEach(book => {
        let newBook = document.createElement("DIV")
        newBook.className = "book"

        let image = document.createElement("IMG")
        image.src = book.image
        newBook.appendChild(image)

        let bookName = document.createElement("H2")
        bookName.innerHTML = book.name
        newBook.appendChild(bookName)

        let bookAuthor = document.createElement("P")
        bookAuthor.innerHTML = "by " + book.author
        newBook.appendChild(bookAuthor)

        bookShelve.appendChild(newBook)
    });
})
