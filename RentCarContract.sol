// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CarRent{

    address owner;

    constructor() {
        owner = msg.sender;
    }

    // wypozyczajacy/uzytkownik
    struct Renter {
        address payable walletAddress;
        string firstName;
        string lastName;
        bool canRent;
        bool active;
        uint balance;
        uint start;
        uint end;
    }

    function getOwner() public view returns (address){
        return owner;
    }
    // dict z wypozyczajacymi
    mapping (address => Renter) public renters;

    // dodaj wypozyczajacego
    function addRenter(address payable walletAddress, string memory firstName, string memory lastName, bool canRent, bool active, uint balance, uint start, uint end) public {
        renters[walletAddress] = Renter(walletAddress, firstName, lastName, canRent, active, balance, start, end);
    }

    // wypozycz auto
    function checkOut(address walletAddress) public {
        require(renters[walletAddress].canRent == true, "Juz wypozyczasz auto!");
        renters[walletAddress].active = true;
        renters[walletAddress].start = block.timestamp;
        renters[walletAddress].canRent = false;
    }

    // zwroc auto
    function checkIn(address walletAddress) public {
        require(renters[walletAddress].active == true, "Najpierw wypozycz auto!");
        renters[walletAddress].active = false;
        renters[walletAddress].end = block.timestamp;
    }


    function balanceOfRenter(address walletAddress) public view returns(uint) {
        return renters[walletAddress].balance;
    }

    function renterTimespan(uint start, uint end) internal pure returns(uint) {
        return end - start;
    }

    function getTotalDuration(address walletAddress) public view returns(uint) {
        require(renters[walletAddress].active == false, "Bike is currently checked out.");
        uint timespan = renterTimespan(renters[walletAddress].start, renters[walletAddress].end);
        uint timespanInMinutes = timespan / 60;
        return timespanInMinutes;
    }
}
