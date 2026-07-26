import Navbar from './components/Navbar'
import HeroSection from './components/HeroSection'
import FeaturesSection from './components/FeaturesSection'
import HowItWorksSection from './components/HowItWorksSection'
import FAQSection from './components/FAQSection'
import Footer from './components/Footer'

function App() {
  return (
    <div className="app-container">
      <Navbar />
      <HeroSection />
      <FeaturesSection />
      <HowItWorksSection />
      <FAQSection />
      <Footer />
    </div>
  )
}

export default App
