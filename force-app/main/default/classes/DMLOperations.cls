/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Your Name
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        // Set some fields on the Account
         Account newAccount = new Account(Name = 'Mantech LLC');
        // Insert the Account into the database
         insert newAccount;
        // Return the Id of the newly created Account
        return newAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account newAccount = new Account();
        newAccount.Name = name;
        newAccount.Industry = industry;
       // Insert the Account
        insert NewAccount;
        
    } 

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact =new Contact();
        String firstName;
        string lastName = 'Doe';
        // Set some fields on the Contact
        newContact.FirstName =firstName;
        newContact.LastName = lastName;
        // Set the AccountId field to the given accountId
          newContact.AccountId = accountId;
        // Insert the Contact into the database 
        insert newContact;
        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        Contact newContact = new Contact();
        newContact.Id = contactId;
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        Contact existContact = [SELECT Id FROM Contact WHERE Id = :newContact.Id];
        // Update the Contact's last name
          existContact.LastName = newLastName;
        // Update the Contact in the database
        upsert existContact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
         // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity newOpp = [Select Id ,StageName From Opportunity Where Id =:oppId];

        // Update the Opportunity's stage
         newOpp.StageName = newStage;
        // Update the Opportunity in the database
        upsert newOpp;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
    Account newAccount = [SELECT Id FROM Account WHERE Id = :accountId];
     newAccount.Name= newName;
     newAccount.Industry=newIndustry;
        // Update the Account with the given Id with the new name and industry
        upsert newAccount;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
        for (Opportunity oppList: opportunities) {
            // Set the Opportunity's Stage to Qualification
            oppList.StageName='Qualification';
            // Set the Opportunity's Close Date to 3 months from today
            oppList.CloseDate= Date.today().addMonths(3);
            // Set the Opportunity's Amount to 50000
            oppList.Amount = 50000.00;
             // Upsert the opportunities List so that records are either updated or created
            Upsert oppList;
        }       
       
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        Account upsertedAccount = upsertAccount(accountName);
        List<Opportunity> opportunitiesToUpsert = new List<Opportunity>();
        // Loop through each Opportunity name
        for (string oppName: oppNames) {
           List< Opportunity> existingOpportunities = [SELECT Id, Name FROM Opportunity 
            WHERE Name = :oppName AND AccountId = :upsertedAccount.Id];
            if (existingOpportunities.isEmpty()) {
                // Create a new Opportunity if it does not exist
                Opportunity newOpportunity = new Opportunity(
                    Name = oppName,
                    AccountId = upsertedAccount.Id,
                    CloseDate = Date.today().addDays(30),
                    StageName = 'Prospecting'             
                );
                opportunitiesToUpsert.add(newOpportunity);
            } else {
                // Update the existing Opportunity if it already exists
                Opportunity existingOpportunity = existingOpportunities[0];
                opportunitiesToUpsert.add(existingOpportunity);
            }
        }
    
        // Upsert the list of Opportunities
        if (!opportunitiesToUpsert.isEmpty()) {
            upsert opportunitiesToUpsert;
        }
    }
            

    
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        Account account;
            // if the Account exists, update the description
            if(!accounts.isEmpty()){
                account= accounts[0];
                account.Description='Updated Account';
          }else {
            account= new account(Name = accountName , Description ='New Account');
          }
          Upsert account;
          return account;
            }
		
    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
        Map<String, Id> accountMap = new Map<String, Id>();
    
        // Collect the unique last names from Contacts to query Accounts
        Set<String> lastNames = new Set<String>();
        for (Contact contact : contactsToUpsert) {
            if (contact.LastName != null) {
                lastNames.add(contact.LastName);
            }
        }
        
        // Query existing Accounts with names that match the last names of Contacts
        List<Account> existingAccounts = [SELECT Id, Name FROM Account WHERE Name = :lastNames];
        
        // Populate the map with Account names and their IDs
        for (Account acc : existingAccounts) {
            accountMap.put(acc.Name, acc.Id);
        }
        
        // Loop through each Contact to link to the correct Account
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountsToInsert = new List<Account>();
        
        for (Contact contact : contactsToUpsert) {
            if (contact.LastName != null) {
                Id accountId = accountMap.get(contact.LastName);
                
                if (accountId == null) {
                    // No existing Account found, so create a new one
                    Account newAccount = new Account(Name = contact.LastName);
                    accountsToInsert.add(newAccount);
                    // Temporarily set the Account Id to null as we don't have it yet
                    contact.AccountId = null;
                } else {
                    // Existing Account found
                    contact.AccountId = accountId;
                }
                contactsToUpdate.add(contact);
            }
        }
        
        // Insert new Accounts
        if (!accountsToInsert.isEmpty()) {
            insert accountsToInsert;
            // Update the accountMap with newly inserted Accounts
            for (Account acc : accountsToInsert) {
                accountMap.put(acc.Name, acc.Id);
            }
        }
        
        // Update Contact's AccountId with the newly created Accounts' Ids
        for (Contact contact : contactsToUpdate) {
            if (contact.AccountId == null && contact.LastName != null) {
                contact.AccountId = accountMap.get(contact.LastName);
            }
        }
        
        // Upsert Contacts
        upsert contactsToUpdate;
    }

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Id> leadList = new List<Id>();
        // Loop through each Lead name
       for (String newLeadName : leadNames) {
         // Insert the Leads
         Lead newLead = new Lead();
         newLead.LastName = newLeadName;
         newLead.Company = 'DML4';
         newLead.Status ='New';
         insert newLead;
         leadList.add(newLead.Id);
       }
       // Delete the Leads
       for (Id leadId: leadList) {
        Lead lead=[Select Id from Lead Where Id = :leadId];

        delete lead;
       }
        
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
       
        // List to hold the cases that will be created
    List<Case> casesToCreate = new List<Case>();
    
    // Loop to create the specified number of Cases
    for (Integer i = 0; i < numOfCases; i++) {
        Case newCase = new Case();
        newCase.AccountId = accountId;
        newCase.Subject = 'Case ' + (i + 1);  // Set a unique subject or any required fields
        newCase.Status = 'New';  // Set a default status or any required fields
        casesToCreate.add(newCase);
    }
    
    // Insert the Cases
    insert casesToCreate;
    
    // Delete the Cases
    delete casesToCreate;
}

      
    }