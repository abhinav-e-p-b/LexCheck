import React from 'react';
import { Play } from 'lucide-react';

const HeroSection: React.FC = () => {
  return (
    <section className="hero text-center" id="download">
      <div className="container animate-fade-in-up">
        <div className="hero-badge">
          <span className="hero-badge-dot"></span>
          Trusted by Indian Youth. Live now.
        </div>
        
        <h1>
          LexCheck, India’s First<br />
          Proactive Legal AI
        </h1>
        
        <p>
          Discover your legal boundaries before crossing them.
          Instant plain-language legal awareness for teenagers.
        </p>
        
        <div className="hero-buttons">
          <a href="/lexcheck.apk" download className="btn btn-primary">
            Download APK Now
          </a>
          <a href="#demo" className="btn btn-outline">
            <Play size={18} fill="currentColor" /> Watch demo
          </a>
        </div>
      </div>
    </section>
  );
};

export default HeroSection;
