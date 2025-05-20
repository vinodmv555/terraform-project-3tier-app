// import { useState } from 'react';
import './App.css';

// function App() {
//   const [users, setUsers] = useState([]);
//   const [inputUser, setInputUser] = useState('');

//   const addUser = () => {
//     if (inputUser.trim() !== '') {
//       setUsers([...users, inputUser]);
//       setInputUser('');
//     }
//   };

//   const deleteUser = (user) => {
//     setUsers(users.filter(u => u !== user));
//   };

//   return (
//     <div className="min-h-screen bg-blue-100 p-4">
//       <h1 className="text-4xl font-bold text-center mb-8">My App</h1>

//       <div className="max-w-xl mx-auto bg-white shadow-lg rounded-lg p-6">
//         <div className="flex gap-2 mb-4">
//           <input
//             type="text"
//             className="border rounded-md p-2 flex-grow"
//             placeholder="Enter user name"
//             value={inputUser}
//             onChange={(e) => setInputUser(e.target.value)}
//           />
//           <button
//             onClick={addUser}
//             className="bg-green-500 text-white rounded-md px-4 py-2 hover:bg-green-600"
//           >
//             Add User
//           </button>
//         </div>

//         <button
//           onClick={() => alert(users.join(', ') || 'No users available')}
//           className="bg-blue-500 text-white rounded-md px-4 py-2 mb-4 hover:bg-blue-600 w-full"
//         >
//           List Users
//         </button>

//         <ul className="mt-4">
//           {users.map((user, index) => (
//             <li key={index} className="flex justify-between items-center border-b py-2">
//               <span>{user}</span>
//               <button
//                 onClick={() => deleteUser(user)}
//                 className="bg-red-500 text-white rounded-md px-3 py-1 hover:bg-red-600"
//               >
//                 Delete
//               </button>
//             </li>
//           ))}
//         </ul>
//       </div>
//     </div>
//   );
// }

// export default App;



export default function App() {
  return (
  <div class="container">
    <header class="header">
      <h1>User Management</h1>
    </header>
    
    <main class="main-buttons">
      <button class="btn list">List Users</button>
      <button class="btn add">Add User</button>
      <button class="btn edit">Edit User</button>
      <button class="btn delete">Delete User</button>
    </main>
  </div>
  );
}
