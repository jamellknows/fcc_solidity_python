pragma solidity >=0.6.0 < 0.9.0;

contract SimpleStorage{
    //store variables as a name
    uint256 favouriteNumber;

    //This is a comment!
    //structs are like classes
    struct People{
        uint256 favouriteNumber;
        string name;
    }
    //declare a new array of new type
    People [] public people;

    mapping(string => uint256) public nameToFavouriteNumber;

    // create a new variable type called/of mapping it has 2 data types one that points to another
    //maps a variable passed in of type string or 1 into type 2 which is a number
    //so it's liek a scaffold
    function store(uint256 _favouriteNumber) public {
        favouriteNumber = _favouriteNumber;
    }

    function retrieve() public view  returns (uint256){
        return favouriteNumber;
    }

    function addPerson(string memory _name, uint256 _favouriteNumber) public{
        people.push(People(_favouriteNumber, _name));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }

}