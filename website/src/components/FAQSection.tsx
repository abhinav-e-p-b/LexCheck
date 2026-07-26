import { useState } from 'react';
import { Plus, Minus } from 'lucide-react';

const FAQSection = () => {
  const [openIndex, setOpenIndex] = useState<number | null>(null);

  const faqs = [
    {
      q: "What is LexCheck?",
      a: "LexCheck is a conversational AI platform where teenagers describe a real or hypothetical situation in plain, everyday language — and instantly receive a clear legal verdict, risk severity, and real case context."
    },
    {
      q: "Is it really anonymous?",
      a: "Yes, LexCheck is anonymous by default. No login is required for any core functionality. No data is stored against your identity, and no query history is retained after your session ends."
    },
    {
      q: "Does this replace a lawyer?",
      a: "No. LexCheck provides legal awareness, not legal advice. It is a proactive decision companion to help you understand legal boundaries before you act. For specific legal situations, always consult a qualified advocate."
    },
    {
      q: "How accurate is the AI?",
      a: "The AI is powered by Retrieval-Augmented Generation (RAG) over a curated, verified Indian legal corpus (BNS, IT Act, POCSO, JJ Act). Every response is grounded in actual retrieved legal text and real court cases, ensuring accuracy."
    }
  ];

  return (
    <section className="section" id="faq" style={{ background: 'var(--bg-light)' }}>
      <div className="container" style={{ display: 'flex', flexWrap: 'wrap', gap: '4rem' }}>
        
        <div style={{ flex: '1 1 300px' }}>
          <h2 style={{ fontSize: '2.5rem', letterSpacing: '-0.02em', marginBottom: '1rem' }}>Frequently<br/>asked questions</h2>
        </div>

        <div style={{ flex: '2 1 500px', display: 'flex', flexDirection: 'column', gap: '1rem' }}>
          {faqs.map((faq, i) => (
            <div 
              key={i} 
              onClick={() => setOpenIndex(openIndex === i ? null : i)}
              style={{ background: 'white', padding: '1.5rem', borderRadius: '16px', border: '1px solid #e2e8f0', cursor: 'pointer', transition: 'all 0.2s' }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <h4 style={{ fontSize: '1.1rem', fontWeight: 600 }}>{faq.q}</h4>
                <button style={{ width: '32px', height: '32px', borderRadius: '50%', background: '#f1f5f9', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                  {openIndex === i ? <Minus size={16} /> : <Plus size={16} />}
                </button>
              </div>
              
              {openIndex === i && (
                <div style={{ marginTop: '1rem', color: 'var(--text-muted)', lineHeight: '1.6', animation: 'fadeInDown 0.3s ease' }}>
                  {faq.a}
                </div>
              )}
            </div>
          ))}
        </div>

      </div>
    </section>
  );
};

export default FAQSection;
