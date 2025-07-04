// File: src/pages/LocalhostPage.jsx (React + Vite setup)

import React, { useState } from 'react';

const PortChooser = () => {
  const [port, setPort] = useState(5174);

  return (
    <div style={{ padding: '1em', fontFamily: 'sans-serif' }}>
      <h2>🌐 Localhost Tunnel Generator</h2>
      <p>
        Running on&nbsp;
        <label htmlFor="port">local port</label>
        &nbsp;
        <input
          style={{ width: '5em' }}
          type="number"
          id="port"
          name="port"
          min="1"
          max="65535"
          value={port}
          onChange={(e) => setPort(e.target.value)}
        />
        ?
      </p>
      <p><strong>Use this command:</strong></p>
      <pre>
        <code>{`ssh -R 80:localhost:${port} localhost.run`}</code>
      </pre>
    </div>
  );
};

export default function LocalhostPage() {
  return (
    <div className="localhost-page">
      <h1>🚀 ForgeFlowAI: Local Dev Tunnels</h1>
      <p>
        Instantly tunnel your localhost port to the public internet with
        <code> localhost.run </code>. No setup or download required.
      </p>
      <PortChooser />
    </div>
  );
}

// Route this in your router (e.g. React Router)
// <Route path="/localhost" element={<LocalhostPage />} />
