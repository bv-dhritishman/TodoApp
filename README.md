# TodoApp using Ruby on Rails.

## MVC Framework

MVC is an architectural pattern that divides an application into three logical components i.e. models, views and controller. Each of these components handle specific aspects of the application.

- **Model**: The Model component corresponds to all the data-related logic that the user works with. This can represent either the data that is being transferred between the View and Controller components or any other business logic-related data.
- **View**: The View component is used for all the UI logic of the application.
- **Controller**: Controllers act as an interface between Model and View components to process all the business logic and incoming requests, manipulate data using the Model component and interact with the Views to render the final output.


---

### What does `rails` or `rake db:migrate` do ?

Migrations is way of of updating the database from current version to a newer version. Migrations are created when we create new models or use the command `rails generate migration`. Using migrations we can create/drop tables, add/remove/change columns and indices.

Rails keeps track of all the migrations applied till now. When we apply `rake db:migrate`, only those migrations are applied which have not been applied previously. We can also go back to previous versions using `rake db:rollback`.

---

### Routes in Rails

The rails router recognizes URLSs and redirects incoming requests to controllers and actions. It can also generate paths and URLs avoiding the need for manually creating them.

The default rails can declare routes for index, show, new, edit, create, update and destroy actions in a single line of code using `resources todo_lists`.

We can have nested resources which creates logical relations between resources.

```ruby
resources :todo_list do
  resources :todo_items
end
```

We can add more member routes by adding the member block to the resource block.
```ruby
resources :todo_items do
  member do
    patch :complete, :incomplete
  end
end
```

---

#### For `todo_list`

1. `resources :todo_lists` create all the default routes for the standard CRUD operations.
2. `rails g controller todo_lists` creates a controller class where we will define the methods for CRUD operations.
3. `rails g model todo_lists title:string description:text` creates a model for Todo Lists with the fields `title` and `description`.
4. Next we create the views component for different CRUD operations for Todo Lists.

	> Rails can do these entire operation using scaffolding. It autogenerates full CRUD web interface for usually a single table.
	`rails g scaffold todo_list title:string description:text`.

	> To set the root of the application, use `root "todo_lists#index` in `config/routes.rb`. This sets the index page of todo_list as the root of the application.

5. Next we run `rails db:migrate` to update the database.
6. Add validations to todo_list so that empty titles are not entered.

#### For `todo_items`

1. Create model `rails g model todo_item content:string completed:boolean todo_list:references`
2. Add validations so that empty todo items are not entered
2. Migrate database `rails db:migrate`
3. Create routes (add nested `resources :todo_items`, then `rails routes`)
4. Create controller (`rails g controller todo_items` and write `create` and `destroy` method)
5. Create views (forms and show)
6. Add ability to mark items complete/incomplete

---

### Security

Below listed are some attacks and their countermeasures.

- Session Hacking (Cookie sniffing):
	- Force SSL: In config file do `config.force_ssl = true`
	- Provide _Log-Out button_ and make it _prominent_.
	- Rotating encrypted and signed configurations.
	- Not store credit information in session to avoid Replay attacks.
	- Session Fixation: Reset session during sign-in and sign out.
	- Set expiry to sessions.
- CSRF (cross-site request forgery):
	- Add required security token
	- destroy previous cookies.

	> Cross-site scripting (XSS) vulnerabilities can bypass all CSRF protections.

- Redirection and Files: Redirect users to phishing links
	- allow only select parameters
	- Do not allow the user to supply (parts of) the URL to be redirected to.
	- File uploads should not overwrite important files. Check for valid file names.
	- Process files asynchronously as synchronous processing are vulnerable of DOS attacks.
	- Users cannot download arbitrary files.
- Intranet and Admin security
	- Add special passwords in the admin interface.
	- Limit login to some IP addresses only. Although one may bypass this using proxy.
	- Make special separate domain for admin interface.
- User Management:
	- Use common up-to-date plugins for authorization and authentication instead of making on your own.
	- Display generic error message such as 'username or password not correct' instead of 'username not found'. We can add CAPTCHA after a number fo failed logins from a single IP address.
	- Make change-password form safe against CSRF and require to enter the old password.
	- Require user to enter password while changing email.
	- Review application logic and eliminate all CSRF and XSS vulnerabilities.
	- Add positive and negative CAPTCHAs to avoid bots.
	- Donot puts passwords/credentials and other sensitive data in log files. Use filters.
	- In Ruby regex, ^ and $ match line beginning and ending. Use \A and \z to match string beginning and ending.
	- No user input data is secure, until proven otherwise, and every parameter from the user can be potentially manipulated. Query user's access rights.
- Injection
	- While sanitizing, verifying something, prefer permitted lists over restricted lists. Use before_action except: instead of only: so we don't forget to enable security checks in newly added actions.
	- **SQL injection**: Influencing database queries by manipulationg web application parameters. Use countermeasures such as `Model.find(id)` or `Model.find_by_some_thing(something)`, `Model.where("login = ? AND password = ?", entered_user_name, entered_password).first` or `Model.where(login: entered_user_name, password: entered_password).first`, `sanitize_sql()`.
	- **Cross-site scripting (XSS)**: An attacker injects some code, the web application saves it and displays it on a page, later presented to a victim.
		- Temporary fix to cookie theft is using httponly cookie.
	Filter malicious input. Use permitted list instead of restricted list. Rails' sanitize() methods fends off encoding attacks.
	- **CSS injection**: Think twice before allowing custom CSS in the web app. This is possible as some browsers allowed JS in CSS. Using Rails' `sanitize()` method as a model for permitted CSS filter.
	- **Textile injection**: Use permitter input filters when using some other mark-up language which is being converted to HTML.
	- **Ajax injection**: While using actions that return a string, rather than rendering a view, you have to escape the return value in the action.
	- **Command line injection**: If command line is necessary use `system`.