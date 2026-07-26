import React from 'react';

const Footer: React.FC = () => {
  return (
    <footer style={{ background: '#0f172a', color: 'white', padding: '6rem 0 2rem' }}>
      <div className="container">
        
        <div style={{ background: 'white', color: '#0f172a', padding: '4rem 2rem', borderRadius: '32px', textAlign: 'center', marginBottom: '6rem' }}>
          <h2 style={{ fontSize: '2.5rem', marginBottom: '1rem', letterSpacing: '-0.02em' }}>Your next legal clarity is waiting</h2>
          <p style={{ color: 'var(--text-muted)', marginBottom: '2rem', maxWidth: '600px', margin: '0 auto 2rem' }}>
            Join Indian youth saving themselves from legal trouble every day. Free to download. Free to use. Always anonymous.
          </p>
          <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem', maxWidth: '400px', margin: '0 auto' }}>
            <a href="/lexcheck.apk" download className="btn btn-dark" style={{ width: '100%' }}>
              Download APK Now
            </a>
          </div>
        </div>

        <div style={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'space-between', gap: '4rem', marginBottom: '4rem' }}>
          <div>
            <div className="logo logo-white" style={{ marginBottom: '1rem' }}>LexCheck</div>
            <p style={{ color: '#94a3b8', maxWidth: '300px', fontSize: '0.9rem' }}>
              Disclaimer: LexCheck provides legal awareness, not legal advice. For your specific situation, please consult a qualified advocate.
            </p>
          </div>

          <div style={{ display: 'flex', gap: '4rem' }}>
            <div>
              <h5 style={{ marginBottom: '1.5rem', fontSize: '1rem' }}>Quick links</h5>
              <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
                <li><a href="#" style={{ color: '#94a3b8' }}>Home</a></li>
                <li><a href="#features" style={{ color: '#94a3b8' }}>Features</a></li>
                <li><a href="#how-it-works" style={{ color: '#94a3b8' }}>How it works</a></li>
              </ul>
            </div>
            
            <div>
              <h5 style={{ marginBottom: '1.5rem', fontSize: '1rem' }}>Support</h5>
              <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
                <li><a href="#faq" style={{ color: '#94a3b8' }}>FAQs</a></li>
                <li><a href="#" style={{ color: '#94a3b8' }}>Contact</a></li>
                <li><a href="#" style={{ color: '#94a3b8' }}>Privacy Policy</a></li>
                <li><a href="#" style={{ color: '#94a3b8' }}>Terms & Conditions</a></li>
              </ul>
            </div>
          </div>
        </div>

        <div style={{ borderTop: '1px solid rgba(255,255,255,0.1)', paddingTop: '2rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center', color: '#64748b', fontSize: '0.9rem' }}>
          <p>Copyright © 2026 LexCheck</p>
        </div>

      </div>
    </footer>
  );
};

export default Footer;
