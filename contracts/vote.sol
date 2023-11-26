//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.19;

import "hardhat/console.sol";

contract Vote {
  struct Proposal {
    string name;
    uint votesCount;
  }
  struct Voter {
      bool voted;  // true si esa persona ya ha votado
      uint vote;   // índice de la propuesta votada
  }
  Proposal[] public proposals;

  address chairperson;

  mapping(address => Voter) public voters;

  modifier onlyAdministrator() {
    require(msg.sender == chairperson,"the caller of this function must be the administrator");
    _;
  }

  modifier onlyUsersNotVotedYet() {
    Voter storage sender = voters[msg.sender];
    require(!sender.voted,"you already voted");
    _;
  }

  constructor(){
    ///console.log("set chairperson",_address);
    chairperson=msg.sender;
  }

  function addProposal(string memory _name) public onlyAdministrator{
    //console.log("set proposal",_name);
    proposals.push(Proposal({
      name: _name,
      votesCount: 0
    }));
  }

 function vote(uint32 index) public onlyUsersNotVotedYet{
    Voter storage sender = voters[msg.sender];
    proposals[index].votesCount += 1;
    sender.voted=true;
    sender.vote=index;
  }
//funcion que muestra a la persona de la silla o a cargo
function getChairPerson() public view returns (address) {
    return chairperson;
  }
  //funcion que muestra las propuestas
  function getProposals() public view returns (uint256) {
    return proposals.length;
  }
  //funcion que muestra la informacion de los participantes
  function getInfoProposals() public view returns (Proposal[] memory){
    return proposals;
  }
  //funcion que muestra los votos por Id
  function getVotesById(uint index) public view returns(uint256){
    return proposals[index].votesCount;
  }
}