const editContactMethods = document.getElementById('js-edit-contact-methods');

if (editContactMethods) {

  // Get the "add contact method" button
  const addContactMethod = document.getElementById('js-add-contact-method');

  // Add an event listener
  addContactMethod.addEventListener('click', function(event) {

    event.preventDefault();

    // Get the index of the new contact method we're adding
    let newIndex = editContactMethods.firstElementChild.childElementCount + 1;

    // Add a new input to the names column
    let nameColumn = editContactMethods.firstElementChild;
    let newNameInput = document.createElement('input');
    newNameInput.type = "text";
    newNameInput.name = "user[contact_methods][" + newIndex + "][name]";
    newNameInput.tabIndex = newIndex + 2;
    nameColumn.appendChild(newNameInput);

    // Add a new input to the values column
    let valueColumn = editContactMethods.lastElementChild;
    let newValueInput = document.createElement('input');
    newValueInput.type = "text";
    newValueInput.name = "user[contact_methods][" + newIndex + "][value]";
    newValueInput.tabIndex = newIndex + 2;
    valueColumn.appendChild(newValueInput);

  })

}
