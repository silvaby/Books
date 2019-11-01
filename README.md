# Books

[![Platform](https://img.shields.io/cocoapods/p/SlideController.svg?style=flat)](http://cocoapods.org/pods/SlideController)

## Task

### Необходимо разработать приложения для iOS, которое использует google books API
https://developers.google.com/books для поиска и получения списка книг по автору и/или названию книги.

В приложении должна быть возможность ввести название книги и отобразить список найденных книг в `UITableView`. 

В списке, для каждой найденной книги, нужно отобразить название, автора, количество страниц в книге и небольшую картинку с обложкой книги.

Приложение должно работать на iPhone Simulator iOS 12.2 только в портретном режиме.

**Желательно:**
* реализовать аутентификацию через OAuth 2.0;
* придерживаться MVC;
* использовать URLSession для сетевых запросов;
* использовать возможности многопоточного программирования.

## How to use

1. Download the project from GitHub.
2. You need an internet connection for the app to work properly.
3. Change your region before running this application. Select USA or Europe. You can use any free VPN service.
4. Run the project using the `Books.xcworkspace` file in Book folder.
5. Select a simulator iOS device or connect iOS device.
6. Push "RUN" button. Wait for the app to load in the simulator or device.
7. Enter a book title in the search bar. Cyrillic available.
8. Enjoy! You will see the first 40 books (book title, authors, count of pages and picture of a book cover). 📚 
9. You can enter a book title again.
