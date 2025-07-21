// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This smart contract allows users to register and manage their profile information.
// Each user can register once and update their details.

contract UserProfileManager {

    // 1. Define the User struct
    // A struct is a custom data type that groups together several variables.
    // Here, it defines what information each user's profile will contain.
    struct User {
        string name;         // User's name
        uint256 age;         // User's age
        string email;        // User's email address
        uint256 registrationTimestamp; // Timestamp when the user registered
        bool isRegistered;   // A flag to check if the address is already registered
    }

    // 2. State Variable to Store User Profiles
    // A mapping is like a hash table or dictionary.
    // It maps an address (the unique identifier for a user on Ethereum)
    // to their User struct.
    // `public` automatically creates a getter function for this mapping,
    // allowing anyone to query a user's profile directly.
    mapping(address => User) public users;

    // 3. Events for Transparency and Off-Chain Monitoring
    // Events are a way for your contract to communicate that something important
    // has happened. They are stored on the blockchain and can be listened to
    // by external applications (like a web frontend).
    event UserRegistered(address indexed userAddress, string name, uint256 timestamp);
    event ProfileUpdated(address indexed userAddress, string newName, uint256 newAge, string newEmail);

    // 4. Function to Register a New User
    // This function allows a new user to create their profile.
    // `public` means anyone can call this function.
    function register(string memory _name, uint256 _age, string memory _email) public {
        // Validation: Ensure the user is not already registered.
        // `require` is used for input validation. If the condition is false,
        // the transaction is reverted, and any gas spent is refunded (except for the gas
        // used up to the point of the revert).
        require(!users[msg.sender].isRegistered, "You are already registered.");

        // Store the new user's information in the 'users' mapping.
        // `msg.sender` is a global variable in Solidity that refers to the address
        // that called the current function. This ensures each user manages their own profile.
        users[msg.sender].name = _name;
        users[msg.sender].age = _age;
        users[msg.sender].email = _email;
        users[msg.sender].registrationTimestamp = block.timestamp; // Record current block timestamp
        users[msg.sender].isRegistered = true; // Mark as registered

        // Emit an event to signal that a new user has been registered.
        emit UserRegistered(msg.sender, _name, block.timestamp);
    }

    // 5. Function to Update an Existing User's Profile
    // This function allows a registered user to modify their profile details.
    // `public` means anyone can call this function.
    function updateProfile(string memory _newName, uint256 _newAge, string memory _newEmail) public {
        // Validation: Ensure the user is already registered before allowing an update.
        require(users[msg.sender].isRegistered, "You are not registered. Please register first.");

        // Update the user's information.
        users[msg.sender].name = _newName;
        users[msg.sender].age = _newAge;
        users[msg.sender].email = _newEmail;

        // Emit an event to signal that the profile has been updated.
        emit ProfileUpdated(msg.sender, _newName, _newAge, _newEmail);
    }

    // 6. View Function to Fetch User Profile Information
    // `getProfile` is a `view` function.
    // `view` functions do not modify the state of the blockchain and therefore
    // do not cost any gas to call (when called externally).
    // It returns the profile information for the calling address.
    function getProfile() public view returns (string memory, uint256, string memory, uint256, bool) {
        // Access the user's data from the 'users' mapping using `msg.sender`.
        User storage user = users[msg.sender];

        // Return all the fields of the User struct.
        return (user.name, user.age, user.email, user.registrationTimestamp, user.isRegistered);
    }

    // 7. Public Getter for a Specific User's Registration Status
    // This is an additional helper function to specifically check if an address is registered.
    // It leverages the `isRegistered` field in the User struct.
    function checkRegistrationStatus(address _userAddress) public view returns (bool) {
        return users[_userAddress].isRegistered;
    }
}
