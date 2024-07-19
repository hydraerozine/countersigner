<!-- src/routes/+page.svelte -->
<script>
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { backend } from "$lib/canisters";

  onMount(async () => {
    try {
      await backend.registerUser();
    } catch (error) {
      console.error("Error registering user:", error);
    }
  });

  function showRegisterAsset() {
    goto('/register');
  }

  function showLendAndEarn() {
    goto('/lend');
  }
</script>

<main>
  <header>
    <div class="logo">
      <svg viewBox="0 0 100 100" width="40" height="40">
        <path d="M50 0 L100 50 L50 100 L0 50 Z" fill="#00BFFF" />
      </svg>
      <span>Countersigner</span>
    </div>
    <div class="timestamp">
      {new Date().toLocaleTimeString()} | {new Date().toLocaleDateString()}
    </div>
  </header>
  
  <section>
    <h1>Countersigner</h1>
    <h2>Login & Signup</h2>
    
    <div class="button-container">
      <button class="water" on:click={showRegisterAsset}>Register Asset</button>
      <button class="earth" on:click={showLendAndEarn}>Lend & Earn</button>
    </div>
  </section>
</main>

<style>
  :global(body) {
    background-color: #000;
    color: #fff;
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
  }

  main {
    display: flex;
    flex-direction: column;
    height: 100vh;
    padding: 20px;
  }

  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-bottom: 20px;
  }

  .logo {
    display: flex;
    align-items: center;
  }

  .logo span {
    margin-left: 10px;
    font-size: 1.2em;
  }

  .timestamp {
    font-size: 0.8em;
    opacity: 0.7;
  }

  section {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  h1 {
    font-size: 2.5em;
    margin-bottom: 10px;
  }

  h2 {
    font-size: 1.2em;
    margin-bottom: 30px;
    opacity: 0.7;
  }

  .button-container {
    display: flex;
    flex-direction: column;
    width: 100%;
    max-width: 300px;
  }

  button {
    margin: 10px 0;
    padding: 15px;
    background-color: transparent;
    color: white;
    border: 2px solid;
    border-radius: 25px;
    cursor: pointer;
    font-size: 1em;
    transition: all 0.3s ease;
  }

  button:hover {
    background-color: rgba(255, 255, 255, 0.1);
  }

  .water { border-color: #00BFFF; }
  .earth { border-color: #00FF00; }
</style>