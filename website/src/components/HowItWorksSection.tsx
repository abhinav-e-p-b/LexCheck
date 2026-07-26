import { useState } from 'react';

const HowItWorksSection = () => {
  const [activeStep, setActiveStep] = useState(1);

  return (
    <section className="section" id="how-it-works" style={{ background: 'var(--bg-light)' }}>
      <div className="container">
        <div className="text-center" style={{ marginBottom: '4rem' }}>
          <span style={{ display: 'inline-block', padding: '0.5rem 1rem', borderRadius: '9999px', background: 'white', border: '1px solid #e2e8f0', fontSize: '0.875rem', fontWeight: '600', marginBottom: '1rem' }}>
            Your legal clarity, in three taps
          </span>
          <h2 style={{ fontSize: '2.5rem', letterSpacing: '-0.02em' }}>Here's how LexCheck works.</h2>
        </div>
        
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '4rem', alignItems: 'center', justifyContent: 'center' }}>
          <div style={{ flex: '1 1 400px', maxWidth: '500px' }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
              
              <div 
                onClick={() => setActiveStep(1)}
                style={{ 
                  padding: '1.5rem', 
                  background: activeStep === 1 ? 'white' : 'transparent', 
                  borderRadius: '16px', 
                  boxShadow: activeStep === 1 ? '0 4px 6px rgba(0,0,0,0.02)' : 'none', 
                  borderLeft: `4px solid ${activeStep === 1 ? 'var(--primary-purple)' : 'transparent'}`,
                  cursor: 'pointer',
                  transition: 'all 0.3s'
                }}>
                <h4 style={{ fontSize: '1.25rem', marginBottom: '0.5rem', color: activeStep === 1 ? 'var(--text-dark)' : '#94a3b8' }}>Step 1: Ask Anonymously</h4>
                <p style={{ color: activeStep === 1 ? 'var(--text-muted)' : '#94a3b8' }}>Open the app without logging in. Type your scenario in plain English or select a common preset.</p>
              </div>

              <div 
                onClick={() => setActiveStep(2)}
                style={{ 
                  padding: '1.5rem', 
                  background: activeStep === 2 ? 'white' : 'transparent', 
                  borderRadius: '16px', 
                  boxShadow: activeStep === 2 ? '0 4px 6px rgba(0,0,0,0.02)' : 'none', 
                  borderLeft: `4px solid ${activeStep === 2 ? 'var(--primary-purple)' : 'transparent'}`,
                  cursor: 'pointer',
                  transition: 'all 0.3s'
                }}>
                <h4 style={{ fontSize: '1.25rem', marginBottom: '0.5rem', color: activeStep === 2 ? 'var(--text-dark)' : '#94a3b8' }}>Step 2: Get Instant Verdict</h4>
                <p style={{ color: activeStep === 2 ? 'var(--text-muted)' : '#94a3b8' }}>Our AI scans the BNS, IT Act, and POCSO to give you an immediate RiskMeter classification.</p>
              </div>

              <div 
                onClick={() => setActiveStep(3)}
                style={{ 
                  padding: '1.5rem', 
                  background: activeStep === 3 ? 'white' : 'transparent', 
                  borderRadius: '16px', 
                  boxShadow: activeStep === 3 ? '0 4px 6px rgba(0,0,0,0.02)' : 'none', 
                  borderLeft: `4px solid ${activeStep === 3 ? 'var(--primary-purple)' : 'transparent'}`,
                  cursor: 'pointer',
                  transition: 'all 0.3s'
                }}>
                <h4 style={{ fontSize: '1.25rem', marginBottom: '0.5rem', color: activeStep === 3 ? 'var(--text-dark)' : '#94a3b8' }}>Step 3: Read Real Cases</h4>
                <p style={{ color: activeStep === 3 ? 'var(--text-muted)' : '#94a3b8' }}>Understand what actually happened to someone your age who did the same thing.</p>
              </div>
              
            </div>
          </div>
          
          <div style={{ flex: '1 1 300px', display: 'flex', justifyContent: 'center' }}>
            <div style={{ width: '280px', height: '580px', background: '#000', borderRadius: '40px', padding: '10px', boxShadow: '0 25px 50px -12px rgba(0,0,0,0.25)', position: 'relative' }}>
              <div style={{ width: '100%', height: '100%', background: 'linear-gradient(180deg, #1e1e1e 0%, #000 100%)', borderRadius: '32px', overflow: 'hidden', position: 'relative', display: 'flex', flexDirection: 'column' }}>
                <div style={{ padding: '1.5rem 1rem', color: 'white', overflowY: 'auto', flex: 1 }}>
                  <div style={{ fontSize: '0.8rem', opacity: 0.7, marginBottom: '0.75rem' }}>Anonymous Chat</div>
                  
                  {activeStep >= 1 && (
                    <div style={{ background: '#333', padding: '0.85rem', borderRadius: '16px 16px 16px 4px', marginBottom: '1rem', fontSize: '0.85rem', animation: 'fadeInUp 0.3s ease' }}>
                      My friend dared me to record a fight in college and post it. Is that legal?
                    </div>
                  )}

                  {activeStep >= 2 && (
                    <div style={{ background: 'var(--bg-gradient)', padding: '0.85rem', borderRadius: '16px 16px 4px 16px', fontSize: '0.85rem', marginBottom: '1rem', animation: 'fadeInUp 0.3s ease' }}>
                      <div style={{ color: '#f59e0b', fontWeight: 'bold', marginBottom: '0.25rem' }}>🟠 Serious Offence</div>
                      Recording and posting fights violates IT Act Section 66E and BNS provisions. You could face serious charges.
                    </div>
                  )}

                  {activeStep >= 3 && (
                    <div style={{ background: '#222', padding: '0.85rem', borderRadius: '16px 16px 4px 16px', fontSize: '0.8rem', border: '1px solid #444', animation: 'fadeInUp 0.3s ease' }}>
                      <div style={{ color: '#10b981', fontWeight: 'bold', marginBottom: '0.25rem' }}>⚖️ CaseLens</div>
                      In 2019, a teenager in Delhi was charged under Section 66E of the IT Act for sharing a classmate's photograph without consent. The Delhi High Court ruled against the teenager, leading to severe penalties.
                    </div>
                  )}
                  
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default HowItWorksSection;
