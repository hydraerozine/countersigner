<!-- src/routes/register/+page.svelte -->
<script>
  import { backend } from "$lib/canisters";
  import { goto } from '$app/navigation';

  let name = '';
  let description = '';
  let price = '';
  let link = '';

  async function registerAsset() {
    if (name && description && price && link) {
      try {
        await backend.storeAsset(name, description, parseFloat(price), link);
        goto('/');
      } catch (error) {
        console.error("Error storing asset:", error);
      }
    }
  }

  function navigateToLend() {
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
    <div class="timestamp">{new Date().toLocaleString()}</div>
    <div class="menu-toggle">☰</div>
  </header>

  <div class="content">
    <nav>
      <ul>
        <li>Account</li>
        <li on:click={navigateToLend}>Assets</li>
        <li>Shards</li>
        <li>Transactions</li>
        <li>Send | Receive</li>
        <li>Buy | Sell | Trade</li>
        <li>Liquidity Exchange</li>
        <li>Deposit | Withdraw</li>
      </ul>
      <div class="version">Countersigner | Version 1.0</div>
    </nav>

    <section class="main-content">
      <div class="register-asset">
        <h2>Register Asset for Borrowing</h2>
        <form on:submit|preventDefault={registerAsset}>
          <input bind:value={name} placeholder="Asset Name" required />
          <input bind:value={description} placeholder="Description" required />
          <input bind:value={price} type="number" placeholder="Price" required />
          <input bind:value={link} placeholder="Asset Link" required />
          <div class="button-group">
            <button type="submit" class="submit">Submit</button>
            <button on:click={() => goto('/')} class="back">Back</button>
          </div>
        </form>
      </div>
    </section>

    <aside class="sharding-contract">
      <h3>Sharding Contract</h3>
      <div class="contract-icon">
        <svg viewBox="0 0 100 100" width="60" height="60">
          <rect x="10" y="10" width="80" height="80" fill="none" stroke="#00BFFF" stroke-width="4" />
          <line x1="30" y1="30" x2="70" y2="30" stroke="#00BFFF" stroke-width="2" />
          <line x1="30" y1="50" x2="70" y2="50" stroke="#00BFFF" stroke-width="2" />
          <line x1="30" y1="70" x2="70" y2="70" stroke="#00BFFF" stroke-width="2" />
        </svg>
      </div>
    </aside>
  </div>
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
  }

  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 20px;
    background-color: #111;
  }

  .logo {
    display: flex;
    align-items: center;
  }

  .logo span {
    margin-left: 10px;
    font-size: 1.2em;
  }

  .timestamp, .menu-toggle {
    font-size: 0.8em;
  }

  .content {
    display: flex;
    flex-grow: 1;
  }

  nav {
    width: 200px;
    background-color: #111;
    padding: 20px;
  }

  nav ul {
    list-style-type: none;
    padding: 0;
  }

  nav li {
    margin-bottom: 15px;
    cursor: pointer;
  }

  .version {
    position: absolute;
    bottom: 20px;
    font-size: 0.8em;
  }

  .main-content {
    flex-grow: 1;
    padding: 20px;
    overflow-y: auto;
  }

  .register-asset {
    background-color: #111;
    padding: 20px;
    border-radius: 10px;
  }

  .register-asset h2 {
    margin-top: 0;
    color: #00BFFF;
  }

  form {
    display: flex;
    flex-direction: column;
  }

  input {
    margin-bottom: 15px;
    padding: 10px;
    background-color: #222;
    border: 1px solid #444;
    color: #fff;
    border-radius: 5px;
  }

  .button-group {
    display: flex;
    justify-content: space-between;
  }

  button {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    color: #fff;
  }

  .submit {
    background-color: #00BFFF;
  }

  .back {
    background-color: #444;
  }

  .sharding-contract {
    width: 200px;
    background-color: #111;
    padding: 20px;
    text-align: center;
  }

  .contract-icon {
    margin-top: 20px;
  }
</style>