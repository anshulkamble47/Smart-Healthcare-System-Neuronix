import React from 'react';
import { useAppData } from '../context/AppDataContext';
import { useTheme } from '../context/ThemeContext';

const Login = ({ onLogin }) => {
  const { providers, selectProvider, currentProvider } = useAppData();
  const { theme, toggleTheme } = useTheme();

  return (
    <div className="login-shell">
      <div className="login-card">
        <div className="section-header">
          <div>
            <p className="eyebrow">SAMVED Access</p>
            <h1 className="section-title">Lab operations dashboard</h1>
            <p className="section-copy">Choose the provider workspace you want to operate, then continue into the live dashboard.</p>
          </div>
          <button type="button" onClick={toggleTheme} className="toggle-button" aria-label="Toggle theme">
            <span className="toggle-icon toggle-icon-left" aria-hidden="true">
              <i className="fa-solid fa-sun"></i>
            </span>
            <span className="toggle-icon toggle-icon-right" aria-hidden="true">
              <i className="fa-solid fa-moon"></i>
            </span>
            <span className={`toggle-thumb ${theme === 'dark' ? 'translate-x-7' : 'translate-x-0'}`}>
              <i className={`fa-solid ${theme === 'dark' ? 'fa-moon' : 'fa-sun'}`}></i>
            </span>
          </button>
        </div>

        <div className="form-stack mt-8">
          <label className="field">
            <span>Provider Workspace</span>
            <select value={currentProvider.provider_id} onChange={(e) => selectProvider(e.target.value)}>
              {providers.map((provider) => (
                <option key={provider.provider_id} value={provider.provider_id}>
                  {provider.name} ({provider.provider_id})
                </option>
              ))}
            </select>
          </label>

          <button type="button" onClick={onLogin} className="btn-primary justify-center">
            <i className="fa-solid fa-right-to-bracket"></i>
            <span>Enter Dashboard</span>
          </button>
        </div>
      </div>
    </div>
  );
};

export default Login;
