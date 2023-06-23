import React, { useState, useEffect } from 'react';
import axios from 'axios';
import '../styles/user.css';

const Dashboard = () => {
  const [users, setUsers] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const response = await axios.get('http://localhost:3001/user/getUser');
      console.log(users)
      setUsers(response.data);
      console.log(users)
    } catch (error) {
      console.error(error);
    }
  };

  const handleSearch = (event) => {
    const { value } = event.target;
    setSearchQuery(value);
  };
  

  const filteredUsers = users.filter((user) =>
  user.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
  user.email.toLowerCase().includes(searchQuery.toLowerCase())
);


  const handleBanUser = (userId) => {
    
  };

  return (
    <div>
        <h1 className="usersT">Users Management</h1>
        <div className="rounded-input-container">
          <span className="search-icon">&#128269;</span>
          <input
            type="text"
            placeholder="Search users"
            value={searchQuery}
            onChange={handleSearch}
            className="rounded-input"
          />
        </div>
        <table className="user-table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Profile Image</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
  {searchQuery === '' ? (
    users.map((user) => (
      <tr key={user.userId}>
        <td>{user.name}</td>
        <td>{user.email}</td>
        <td>
          <img src={user.profileImage} alt="Profile Image" />
        </td>
        <td>
          <button
            className="ban-button"
            style={{ backgroundColor: 'red' }}
            onClick={() => handleBanUser(user.userId)}
          >
            Ban
          </button>
        </td>
      </tr>
    ))
  ) : (
    filteredUsers.map((user) => (
      <tr key={user.userId}>
        <td>{user.name}</td>
        <td>{user.email}</td>
        <td>
          <img src={user.profileImage} alt="Profile Image" />
        </td>
        <td>
          <button
            className="ban-button"
            onClick={() => handleBanUser(user.userId)}
          >
            Ban
          </button>
        </td>
      </tr>
    ))
  )}
</tbody>
        </table>
      </div>
  );
};

export default Dashboard;
