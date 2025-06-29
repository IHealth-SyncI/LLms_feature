"""
LLM Utilities Module

This module provides centralized LLM configuration and utilities for the FastAPI application.
"""

from langchain_ollama.llms import OllamaLLM
from typing import Optional
import os


def get_llm_instance(
    model: str = "deepseek-r1:1.5b",
    temperature: float = 0.2,
    base_url: str = "http://localhost:11434",
    top_p: float = 0.95,
    max_tokens: int = 1024,
) -> OllamaLLM:
    """
    Returns a configured LLM instance for use across the application.

    Args:
        model (str): The Ollama model to use
        temperature (float): Controls randomness in the response
        base_url (str): Ollama server URL
        top_p (float): Controls diversity via nucleus sampling
        max_tokens (int): Maximum number of tokens to generate

    Returns:
        OllamaLLM: Configured LLM instance
    """
    return OllamaLLM(
        model=model,
        temperature=temperature,
        base_url=base_url,
        top_p=top_p,
        max_tokens=max_tokens,
    )


def get_llm_config() -> dict:
    """
    Returns the current LLM configuration as a dictionary.

    Returns:
        dict: Configuration parameters
    """
    return {
        "model": "deepseek-r1:1.5b",
        "temperature": 0.2,
        "base_url": "http://localhost:11434",
        "top_p": 0.95,
        "max_tokens": 1024,
    }


def update_llm_config(
    model: Optional[str] = None,
    temperature: Optional[float] = None,
    base_url: Optional[str] = None,
    top_p: Optional[float] = None,
    max_tokens: Optional[int] = None,
) -> dict:
    """
    Update LLM configuration parameters.

    Args:
        model (str, optional): New model name
        temperature (float, optional): New temperature value
        base_url (str, optional): New base URL
        top_p (float, optional): New top_p value
        max_tokens (int, optional): New max_tokens value

    Returns:
        dict: Updated configuration
    """
    config = get_llm_config()

    if model is not None:
        config["model"] = model
    if temperature is not None:
        config["temperature"] = temperature
    if base_url is not None:
        config["base_url"] = base_url
    if top_p is not None:
        config["top_p"] = top_p
    if max_tokens is not None:
        config["max_tokens"] = max_tokens

    return config


def validate_llm_connection() -> bool:
    """
    Validates that the LLM service is accessible.

    Returns:
        bool: True if connection is successful, False otherwise
    """
    try:
        llm = get_llm_instance()
        # Try a simple test prompt
        response = llm.invoke("Hello")
        return True
    except Exception as e:
        print(f"LLM connection validation failed: {e}")
        return False
