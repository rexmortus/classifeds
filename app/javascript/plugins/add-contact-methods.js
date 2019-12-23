const editContactMethods = document.getElementById('js-edit-contact-methods');

if (editContactMethods) {

  // Get the "add contact method" button
  const addContactMethod = document.getElementById('js-add-contact-method');

  // Add an event listener
  addContactMethod.addEventListener('click', function(event) {

    event.preventDefault();

    // Get the table body (this sucks)
    let tbody = editContactMethods.children[0].children[0].children[1];

    // Get the index of the new contact method we're adding
    let newIndex = tbody.childElementCount + 1;

    // Create a table row
    let tableRow = document.createElement('tr');

    // CREATE THE TYPE COLUMN/INPUT
    let typeColumn = document.createElement('td');

    // Create the input
    let newTypeInput = document.createElement('input');
    newTypeInput.type = "text";
    newTypeInput.name = "user[contact_methods][" + newIndex + "][name]";
    newTypeInput.tabIndex = newIndex + 2;

    // Put the input in the column
    typeColumn.appendChild(newTypeInput);

    // Put the column into the new row
    tableRow.appendChild(typeColumn);

    tbody.appendChild(tableRow);

    // CREATE THE VALUE COLUMN/INPUT
    let valueColumn = document.createElement('td');

    // Create the input
    let newValueInput = document.createElement('input');
    newValueInput.type = "text";
    newValueInput.name = "user[contact_methods][" + newIndex + "][value]";
    newValueInput.tabIndex = newIndex + 2;

    // Put the input in the column
    valueColumn.appendChild(newValueInput);

    // Put the column into the new row
    tableRow.appendChild(valueColumn);

    // CREATE THE PUBLIC COLUMN/INPUT
    let publicColumn = document.createElement('td');
    publicColumn.className = "public-input";

    // Create the input
    let newPublicInput = document.createElement('input');
    newPublicInput.type = "checkbox";
    newPublicInput.name = "user[contact_methods][" + newIndex + "][public]";

    // Put the input in the column
    publicColumn.appendChild(newPublicInput);

    // Put the column into the new row
    tableRow.appendChild(publicColumn);

    // FINALLY, ADD THE NEW ROW
    tbody.appendChild(tableRow);


  })

}
