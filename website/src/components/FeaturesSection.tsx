import React from 'react';

const FeaturesSection: React.FC = () => {
  return (
    <section className="section text-center" id="features" style={{ background: 'white' }}>
      <div className="container">
        <h2 style={{ fontSize: '3rem', marginBottom: '1rem', letterSpacing: '-0.03em' }}>
          Every day you make decisions.<br />
          <span className="text-gradient">Know the legal line.</span>
        </h2>
        <p style={{ fontSize: '1.25rem', color: 'var(--text-muted)', marginBottom: '4rem', maxWidth: '600px', margin: '0 auto 4rem' }}>
          LexCheck provides clarity on what's legal, what's a grey area, and what's criminal—all in plain language.
        </p>
        
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '2rem', textAlign: 'left' }}>
          
          <div className="glass-panel" style={{ padding: '2rem', background: '#f8fafc', border: '1px solid #e2e8f0', boxShadow: '0 10px 25px -5px rgba(0,0,0,0.05)', transition: 'transform 0.3s' }}>
            <div style={{ width: '48px', height: '48px', borderRadius: '12px', background: 'var(--primary-purple)', color: 'white', display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: '1.5rem', fontSize: '1.5rem', fontWeight: 'bold' }}>1</div>
            <h3 style={{ fontSize: '1.5rem', marginBottom: '1rem' }}>Scenario-Based</h3>
            <p style={{ color: 'var(--text-muted)' }}>Describe your situation naturally. No legal jargon needed. Ask like you're talking to a friend.</p>
          </div>

          <div className="glass-panel" style={{ padding: '2rem', background: '#f8fafc', border: '1px solid #e2e8f0', boxShadow: '0 10px 25px -5px rgba(0,0,0,0.05)', transition: 'transform 0.3s' }}>
            <div style={{ width: '48px', height: '48px', borderRadius: '12px', background: '#f59e0b', color: 'white', display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: '1.5rem', fontSize: '1.5rem', fontWeight: 'bold' }}>2</div>
            <h3 style={{ fontSize: '1.5rem', marginBottom: '1rem' }}>Visual RiskMeter</h3>
            <p style={{ color: 'var(--text-muted)' }}>Instantly see the severity level of your action. From safe green to criminal red, know your risk visually.</p>
          </div>

          <div className="glass-panel" style={{ padding: '2rem', background: '#f8fafc', border: '1px solid #e2e8f0', boxShadow: '0 10px 25px -5px rgba(0,0,0,0.05)', transition: 'transform 0.3s' }}>
            <div style={{ width: '48px', height: '48px', borderRadius: '12px', background: '#10b981', color: 'white', display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: '1.5rem', fontSize: '1.5rem', fontWeight: 'bold' }}>3</div>
            <h3 style={{ fontSize: '1.5rem', marginBottom: '1rem' }}>Real CaseLens</h3>
            <p style={{ color: 'var(--text-muted)' }}>Every answer is backed by real Indian Supreme Court cases, translated into simple 3-sentence stories.</p>
          </div>

        </div>
      </div>
    </section>
  );
};

export default FeaturesSection;
