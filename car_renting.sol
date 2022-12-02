//SPDX-License-Identifier:MIT

import "./alpha.sol";
pragma solidity ^0.8.9;
contract rent is alpha{
    constructor(){
        owner =payable(msg.sender);       
    }
    //STATE VARIABLES ===========================================================================================
    address payable public owner;
    uint startTime;
    uint totalTime;
    enum carStatus{available, rented}
    uint totalRent;

    //CAR STRUCTURES ===========================================================================================
    struct car {
        uint carID;
        string carName;
        address rentedBy;
        uint startTime;
        carStatus checkAvailability;
    }
    struct carInfo{
        uint carID;
        string carName;
    }
  
    carInfo[] carList;

    //MAPPING & MODIFIER =====================================================================================================
    mapping (address => car)userStatus;
    mapping(uint =>  car) carMapping;
    modifier notOwner(){
       require(owner != msg.sender,"Owner can not rent his own car");
        _;
    }

    //EVENTS ==================================================================================================
    event carRented(address indexed renter,string name,uint id);
    event carParked(address indexed renter,string name,uint id,uint rent,uint time);
    event rentPaid(address indexed renter,string name,uint id, uint rent);

//OWNER CAN ADD CAR ==============================================================================================
    function addCar(string memory _carName,uint _carID)public {
        car memory c;
        carInfo memory _carInfo;
        c.carName=_carName;
        c.carID=_carID;
        _carInfo.carName=_carName;
        _carInfo.carID=_carID;
        c.checkAvailability = carStatus.available;
        carList.push(_carInfo);
        carMapping[_carID] = c;
    }
    function CarList() public view returns (carInfo[] memory ){
        return carList;
    }
    
    function RentCar(uint _carID) public notOwner {

        require(carMapping[_carID].checkAvailability == carStatus.available,"This car is already rented by someone");
        carMapping[_carID].rentedBy = msg.sender;
        carMapping[_carID].startTime = block.timestamp;
        carMapping[_carID].checkAvailability = carStatus.rented;
        emit carRented(msg.sender,carMapping[_carID].carName,_carID);
    }

    function checkRent(uint _carID) public returns(uint){
        require(carMapping[_carID].rentedBy == msg.sender,"This car is not rented by you");
        totalTime = (block.timestamp - carMapping[_carID].startTime)/60;
        // ether payment feature 
        // totalRent = (totalTime*1000000000000000000);
        totalRent = totalTime;
        emit carParked(msg.sender,carMapping[_carID].carName,_carID,totalRent,totalTime);
        return totalRent;
    }

    function payRent(uint _carID,uint _rent) public payable {
         require(carMapping[_carID].rentedBy == msg.sender,"This car is not rented by you");
         require(_rent == totalRent,"Please enter correct amount of ether");

        //  owner.transfer(msg.value);
         transfer(owner,_rent);
         carMapping[_carID].checkAvailability = carStatus.available;
         carMapping[_carID].rentedBy = address(0);
         emit rentPaid(msg.sender,carMapping[_carID].carName,_carID,totalRent);
         
    }


}