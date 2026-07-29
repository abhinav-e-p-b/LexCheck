import React from "react";

const HeroSection: React.FC = () => {
  return (
    <section className="hero text-center" id="download">
      <div className="container animate-fade-in-up">

        <div className="hero-badge">
          <span className="hero-badge-dot"></span>
          Trusted by Indian Youth. Live now.
        </div>

        <h1>
          LexCheck, India's First
          <br />
          Proactive Legal AI
        </h1>

        <p>
          Discover your legal boundaries before crossing them.
          Instant plain-language legal awareness for teenagers.
        </p>

        <div className="hero-buttons">
          <a
            href="/lexcheck.apk"
            download
            className="btn btn-primary"
          >
            Download APK Now
          </a>
        </div>

        {/* ================= PRODUCT DEMO ================= */}

        <section className="demo-section">


          <div className="video-wrapper">

            <video
              controls
              preload="metadata"
              poster="src/assets/demo-thumbnail.png"
            >
              <source src="src/assets/demo.mp4" type="video/mp4" />
              Your browser does not support the video tag.
            </video>

          </div>

        </section>

      </div>
    </section>
  );
};

export default HeroSection;