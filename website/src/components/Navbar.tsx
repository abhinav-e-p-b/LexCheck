import React from 'react';
import { Apple, Play } from 'lucide-react';

const Navbar: React.FC = () => {
  return (
    <nav className="navbar">
      <div className="logo">LexCheck</div>
      <div className="nav-links">
        <a href="#download">Download</a>
        <a href="#features">Features</a>
        <a href="#how-it-works">How it works</a>
        <a href="#faq">FAQ</a>
      </div>
    </nav>
  );
};

export default Navbar;
