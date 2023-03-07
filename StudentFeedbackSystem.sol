//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract FeedbackSystem {
  mapping(address => Faculty[]) faculties; 
  mapping(address => TakenCourse[]) takenCourses;
  mapping(address => Courses[]) facultyCourses;
  mapping(address => UserAccount[]) userAccount;
  address owner;
  
  struct UserAccount {
      address userAddress;
      string password;
      string role;
  }

  struct Faculty {
      string rating;
      string comment;
  }

  struct Feedback {
      address to;
      string rating;
      string comment;
  }

  struct Courses {
      address facultyAddress;
      string courseCode;
      string courseTitle;
      string faculty;
  }

  struct TakenCourse{
      string courseCode;
      string courseTitle;
      string faculty;
  }
  Courses[] private courses;

  constructor() {
      owner = msg.sender;
  }

   modifier onlyOwner() {
        require(msg.sender == owner, "You are not allowed");
        _;
    }

  Feedback[] private feedbacks;

  function submitFeedback(address _to, string memory _rating, string memory _comment) public {
      faculties[_to].push(Faculty({
          rating: _rating,
          comment: _comment
      }));

      
      feedbacks.push(
          Feedback(_to, _rating, _comment)
      );
  }

  function getFeedbacksByAddress() public view returns(Faculty[] memory){
      return faculties[msg.sender];
  }

  function getAllFeedbacks() public onlyOwner view returns(Feedback[] memory){
      return feedbacks;
  }

  function addCourses(address _facultyAddress, string memory _courseCode, string memory _courseTitle, string memory _faculty) public onlyOwner {
      courses.push(
          Courses(_facultyAddress, _courseCode, _courseTitle, _faculty)
      );
      facultyCourses[_facultyAddress].push(
          Courses(_facultyAddress, _courseCode, _courseTitle, _faculty)
      );
  }

  function getAllCourses() public view returns(Courses[] memory){
      return courses;
  }

  function createUserAccount(address _userAddress, string memory _password, string memory _role) public onlyOwner {
      userAccount[_userAddress].push(
          UserAccount(_userAddress, _password, _role)
      );
  }

  function getUserAccount() public view returns(UserAccount[] memory) {
      return userAccount[msg.sender];
  }

  function getAssignToCourse(string memory _courseCode, string memory _courseTitle, string memory _faculty) public {
      takenCourses[msg.sender].push(TakenCourse(_courseCode, _courseTitle, _faculty));
  }

  function getAssigneCourses() public view returns (TakenCourse[] memory){
      return takenCourses[msg.sender];
  }

  function getFacultyCourses() public view returns(Courses[] memory){
      return facultyCourses[msg.sender];
  }
}
