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

